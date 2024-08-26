class_name Namespace
extends Node

var blocks: Array = Array()
var parentBlock = null

func wipeNamespace():
	for block: Block in blocks:
		block.wipe()

func propagate_types():
	var stack: Array = Array()
	
	# Find all type input blocks
	var ns_stack: Array = [self]
	while !ns_stack.is_empty():
		var cur: Namespace = ns_stack.pop_back()
		for block: Block in cur.blocks:
			if block is InputBlock and block.connector.takesType:
				stack.push_back(block.connector)
			for ns in block.subNamespaces:
				ns_stack.push_back(ns)
	
	# Propagate type values
	while !stack.is_empty():
		var cur: Connector = stack.pop_back()
		
		assert(cur.takesType and cur.type is TypeType)
		
		# In connectors should have exactly one input (nonzero, else it would not be reached)
		if (cur.isInput and cur.inConnections.size() != 1):
			continue
		# Out connectors should have no in connections (Possible with out-out connection in ui)
		if (!cur.isInput and cur.inConnections.size() != 0):
			continue
		
		# Invariant:
		#   If cur is an input connector, the unique in connection's connector has a value
		#   If cur is an output connector, cur has a value
		assert(!cur.isInput or cur.inConnections[0].value != null)
		assert(cur.isInput or cur.value != null)
		
		if !cur.isInput:
			for connector: Connector in cur.outConnections:
				if connector.takesType:
					assert(connector.type is TypeType)
					stack.push_back(connector)
		else:
			var from = cur.inConnections[0]
			assert(from.takesType and from.type is TypeType)
			var block = cur.parentBlock
			# We shouldn't have reached this connector before
			assert(cur.value == null)
			if block is OutputBlock:
				cur.value = from.value
			elif block is LambdaBlock:
				if cur == block.inputTypeConnector:
					cur.value = from.value
					block.innerInputBlock.connector.type = from.value
				elif cur == block.outputTypeConnector:
					cur.value = from.value
					block.innerOutputBlock.connector.type = from.value
				else:
					assert(false)
				if block.inputTypeConnector.value != null and block.outputTypeConnector.value != null:
					block.outputConnector.type = FunctionType.new(block.inputTypeConnector.value, block.outputTypeConnector.value)
			elif block is FunctionBlock:
				cur.value = from.value
				if block.arg1Connector.value != null and block.arg2Connector.value != null:
					assert(block.resultConnector.type is TypeType)
					block.resultConnector.value = FunctionType.new(block.arg1Connector.value, block.arg2Connector.value)
					stack.append(block.resultConnector)
			elif block is AndBlock:
				cur.value = from.value
				if block.arg1Connector.value != null and block.arg2Connector.value != null:
					assert(block.resultConnector.type is TypeType)
					block.resultConnector.value = AndType.new(block.arg1Connector.value, block.arg2Connector.value)
					stack.append(block.resultConnector)
			elif block is OrBlock:
				cur.value = from.value
				if block.arg1Connector.value != null and block.arg2Connector.value != null:
					assert(block.resultConnector.type is TypeType)
					block.resultConnector.value = OrType.new(block.arg1Connector.value, block.arg2Connector.value)
					stack.append(block.resultConnector)
			elif block is OrLeftBlock:
				assert(cur == block.typeConnector)
				cur.value = from.value
			elif block is OrRightBlock:
				assert(cur == block.typeConnector)
				cur.value = from.value
			elif block is NotElimBlock:
				assert(cur == block.typeConnector)
				cur.value = from.value
				block.resultConnector.type = from.value
			elif block is AndElimBlock:
				assert(cur == block.typeConnector)
				cur.value = from.value
				block.innerOutputBlock.type = from.value
				block.resultConnector.type = from.value
			elif block is OrElimBlock:
				assert(cur == block.typeConnector)
				cur.value = from.value
				block.innerOutputBlock.type = from.value
				block.resultConnector.type = from.value
			else:
				assert(false)

func infer_types():
	var stack: Array = Array()
	var checked: Dictionary = Dictionary()
	
	# Find all type input blocks
	var ns_stack: Array = [self]
	while !ns_stack.is_empty():
		var cur: Namespace = ns_stack.pop_back()
		for block: Block in cur.blocks:
			for connector in block.inputConnectors:
				if !connector.type is UnknownType and !connector.type is TypeType:
					stack.push_back(connector)
			for connector in block.outputConnectors:
				if !connector.type is UnknownType and !connector.type is TypeType:
					stack.push_back(connector)
			for ns in block.subNamespaces:
				ns_stack.push_back(ns)
	
	while !stack.is_empty():
		var cur: Connector = stack.pop_back()
		
		var block: Block = cur.parentBlock
		
		# Invariant cur has a type
		assert(!cur.type is UnknownType)
		
		# Another invariant is that the checked set contains a connector only if it is not UnknownType 
		
		# In connectors should have exactly one input (nonzero, else it would not be reached)
		if (cur.isInput and cur.inConnections.size() != 1):
			continue
		# Out connectors should have no in connections (Possible with out-out connection in ui)
		if (!cur.isInput and cur.inConnections.size() != 0):
			continue
		
		for inConnector: Connector in cur.inConnections:
			if inConnector.type is UnknownType and !checked.has(inConnector):
				inConnector.type = cur.type
				checked[inConnector] = true
				stack.push_back(inConnector)
		
		for outConnector: Connector in cur.outConnections:
			if outConnector.type is UnknownType and !checked.has(outConnector):
				outConnector.type = cur.type
				checked[outConnector] = true
				stack.push_back(outConnector)
		
		if block is InputBlock:
			# Can do inference of outer namespace block or something
			pass
		elif block is OutputBlock:
			pass
		elif block is ApplicatorBlock:
			if cur == block.argConnector || cur == block.resultConnector:
				if !block.argConnector.type is UnknownType and !block.resultConnector.type is UnknownType and block.functionConnector.type is UnknownType:
					assert(!checked.has(block.functionConnector))
					block.functionConnector.type = FunctionType.new(block.argConnector.type, block.resultConnector.type)
					checked[block.functionConnector] = true
					stack.push_back(block.functionConnector)
			elif cur == block.functionConnector:
				if block.functionConnector.type is FunctionType:
					if block.argConnector.type is UnknownType:
						assert(!checked.has(block.argConnector))
						block.argConnector.type = cur.type.domain
						checked[block.argConnector] = true
						stack.push_back(block.argConnector)
					if block.resultConnector.type is UnknownType:
						assert(!checked.has(block.resultConnector))
						block.resultConnector.type = cur.type.codomain
						checked[block.resultConnector] = true
						stack.push_back(block.resultConnector)
				else:
					block.functionConnector.type = UnknownType.new()
			else:
				assert(false)
		elif block is LambdaBlock:
			if cur == block.outputConnector:
				if cur.type is FunctionType:
					if block.innerInputBlock.connector.type is UnknownType:
						assert(!checked.has(block.innerInputBlock.connector))
						block.innerInputBlock.connector.type = cur.type.domain
						checked[block.innerInputBlock.connector] = true
						stack.push_back(block.innerInputBlock.connector)
					if block.innerOutputBlock.connector.type is UnknownType:
						assert(!checked.has(block.innerOutputBlock.connector))
						block.innerOutputBlock.connector.type = cur.type.codomain
						checked[block.innerOutputBlock.connector] = true
						stack.push_back(block.innerOutputBlock.connector)
			else:
				assert(false) # Other connectors are type connectors
		elif block is AndMkBlock:
			if cur == block.input1Connector || cur == block.input2Connector:
				if !block.input1Connector.type is UnknownType and !block.input2Connector.type is UnknownType and block.resultConnector.type is UnknownType:
					assert(!checked.has(block.resultConnector))
					block.resultConnector.type = AndType.new(block.input1Connector.type, block.input2Connector.type)
					checked[block.resultConnector] = true
					stack.push_back(block.resultConnector)
			elif cur == block.resultConnector:
				if block.resultConnector.type is AndType:
					if block.input1Connector.type is UnknownType:
						assert(!checked.has(block.input1Connector))
						block.input1Connector.type = cur.type.type1
						checked[block.input1Connector] = true
						stack.push_back(block.input1Connector)
					if block.input2Connector.type is UnknownType:
						assert(!checked.has(block.input2Connector))
						block.input2Connector.type = cur.type.type2
						checked[block.input2Connector] = true
						stack.push_back(block.input2Connector)
			else:
				assert(false)
		elif block is OrLeftBlock:
			if cur == block.inputConnector:
				if !block.inputConnector.type is UnknownType and !block.typeConnector.value is UnknownType and block.resultConnector.type is UnknownType:
					assert(!checked.has(block.resultConnector))
					block.resultConnector.type = OrType.new(block.inputConnector.type, block.typeConnector.value)
					checked[block.resultConnector] = true
					stack.push_back(block.resultConnector)
			elif cur == block.resultConnector:
				if block.resultConnector.type is OrType:
					if block.inputConnector.type is UnknownType:
						assert(!checked.has(block.inputConnector))
						block.inputConnector.type = cur.type.type1
						checked[block.inputConnector] = true
						stack.push_back(block.inputConnector)
			else:
				assert(false)
		elif block is OrRightBlock:
			if cur == block.inputConnector:
				if !block.inputConnector.type is UnknownType and !block.typeConnector.value is UnknownType and block.resultConnector.type is UnknownType:
					assert(!checked.has(block.resultConnector))
					block.resultConnector.type = OrType.new(block.typeConnector.value, block.inputConnector.type)
					checked[block.resultConnector] = true
					stack.push_back(block.resultConnector)
			elif cur == block.resultConnector:
				if block.resultConnector.type is OrType:
					if block.inputConnector.type is UnknownType:
						assert(!checked.has(block.inputConnector))
						block.inputConnector.type = cur.type.type2
						checked[block.inputConnector] = true
						stack.push_back(block.inputConnector)
			else:
				assert(false)
		elif block is NotElimBlock:
			pass
		elif block is AndElimBlock:
			if cur == block.andConnector:
				if cur.type is AndType:
					if block.innerInputBlock1.connector.type is UnknownType:
						assert(!checked.has(block.innerInputBlock1.connector))
						block.innerInputBlock1.connector.type = cur.type.type1
						checked[block.innerInputBlock1.connector] = true
						stack.push_back(block.innerInputBlock1.connector)
					if block.innerInputBlock2.connector.type is UnknownType:
						assert(!checked.has(block.innerInputBlock2.connector))
						block.innerInputBlock2.connector.type = cur.type.type2
						checked[block.innerInputBlock2.connector] = true
						stack.push_back(block.innerInputBlock2.connector)
			elif cur == block.resultConnector:
				if block.innerOutputBlock.connector.type is UnknownType:
					assert(!checked.has(block.innerOutputBlock.connector))
					block.innerOutputBlock.connector.type = cur.type
					checked[block.innerOutputBlock.connector] = true
					stack.push_back(block.innerOutputBlock.connector)
			else:
				assert(false)
		elif block is OrElimBlock:
			if cur == block.orConnector:
				if cur.type is OrType:
					if block.innerInputBlockl.connector.type is UnknownType:
						assert(!checked.has(block.innerInputBlockl.connector))
						block.innerInputBlockl.connector.type = cur.type.type1
						checked[block.innerInputBlockl.connector] = true
						stack.push_back(block.innerInputBlockl.connector)
					if block.innerInputBlockr.connector.type is UnknownType:
						assert(!checked.has(block.innerInputBlockr.connector))
						block.innerInputBlockr.connector.type = cur.type.type2
						checked[block.innerInputBlockr.connector] = true
						stack.push_back(block.innerInputBlockr.connector)
			elif cur == block.resultConnector:
				if block.innerOutputBlockl.connector.type is UnknownType:
					assert(!checked.has(block.innerOutputBlockl.connector))
					block.innerOutputBlockl.connector.type = cur.type
					checked[block.innerOutputBlockl.connector] = true
					stack.push_back(block.innerOutputBlockl.connector)
				if block.innerOutputBlockr.connector.type is UnknownType:
					assert(!checked.has(block.innerOutputBlockr.connector))
					block.innerOutputBlockr.connector.type = cur.type
					checked[block.innerOutputBlockr.connector] = true
					stack.push_back(block.innerOutputBlockr.connector)
			else:
				assert(false)
		else:
			assert(false)

func propagate_values():
	var stack = Array()
	
	# Find all type input blocks
	var ns_stack: Array = [self]
	while !ns_stack.is_empty():
		var cur: Namespace = ns_stack.pop_back()
		for block: Block in cur.blocks:
			if block is InputBlock and !block.connector.type is TypeType:
				stack.push_back(block.connector)
			for ns in block.subNamespaces:
				ns_stack.push_back(ns)
	
	while !stack.is_empty():
		var cur = stack.pop_back()
		var block = cur.parentBlock
		
		if (cur.isInput and cur.inConnections.size() != 1) or (!cur.isInput and !cur.inConnections.is_empty()):
			continue
		
		assert(cur.value != null)
		
		if !cur.isInput:
			for out in cur.outConnections:
				if out.type.equalTo(cur.type):
					# Check for namespace escaping TODO
					var namespaceLegal = false
					var curNamespace = out.parentBlock.parentNamespace
					while curNamespace != null:
						if curNamespace == cur.parentBlock.parentNamespace:
							namespaceLegal = true
							break
						if curNamespace.parentBlock == null:
							break
						curNamespace = curNamespace.parentBlock.parentNamespace
					if !namespaceLegal:
						continue
					
					if !out.isInput or out.inConnections.size() > 1:
						continue
					
					out.value = cur.value
					stack.push_back(out)
		else:
			var from: Connector = cur.inConnections[0]
			
			if block is OutputBlock:
				assert(cur == block.connector)
				var parentBlock = block.parentNamespace.parentBlock
				if parentBlock is LambdaBlock:
					if parentBlock.innerOutputBlock.connector.value != null:
						parentBlock.outputConnector.value = true
						stack.push_back(parentBlock.outputConnector)
				elif parentBlock is AndElimBlock:
					if parentBlock.innerOutputBlock.connector.value != null:
						parentBlock.resultConnector.value = true
						stack.push_back(parentBlock.resultConnector)
				elif parentBlock is OrElimBlock:
					if parentBlock.innerOutputBlockl.connector.value != null and parentBlock.innerOutputBlockr.connector.value != null:
						parentBlock.resultConnector.value = true
						stack.push_back(parentBlock.resultConnector)
				else:
					assert(parentBlock == null)
			elif block is ApplicatorBlock:
				if block.functionConnector.type is FunctionType and block.argConnector.type.equalTo(block.functionConnector.type.domain) and block.resultConnector.type.equalTo(block.functionConnector.type.codomain) and block.argConnector.value != null and block.functionConnector.value != null:
					block.resultConnector.value = block.argConnector.value
					stack.push_back(block.resultConnector)
			elif block is AndMkBlock:
				if block.input1Connector.value != null and block.input2Connector.value != null:
					block.resultConnector.value = true
					stack.push_back(block.resultConnector)
			elif block is OrLeftBlock:
				if block.inputConnector.value:
					block.resultConnector.value = true
					stack.push_back(block.resultConnector)
			elif block is OrRightBlock:
				if block.inputConnector.value:
					block.resultConnector.value = true
					stack.push_back(block.resultConnector)
			elif block is NotElimBlock:
				block.resultConnector.value = true
				stack.push_back(block.resultConnector)
			else:
				assert(false)

func typeCheck():
	wipeNamespace()
	propagate_types()
	infer_types()
	propagate_values()
	
	return false
