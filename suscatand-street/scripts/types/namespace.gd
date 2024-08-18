class_name Namespace
extends Node

var blocks: Array = Array()
var parentBlock = null

func typeCheck():
	var stack: Array = Array()
	var checked: Dictionary = Dictionary()
	for block: Block in blocks:
		if block is InputBlock:
			stack.append(block.connector)
			checked[block.connector] = true
		elif block is OutputBlock:
			block.connector.value = null
		elif block is ApplicatorBlock:
			block.argConnector.type = UnknownType.new()
			block.functionConnector.type = UnknownType.new()
			block.resultConnector.type = UnknownType.new()
			block.argConnector.value = null
			block.functionConnector.value = null
			block.resultConnector.value = null
		elif block is LambdaBlock:
			block.innerInputBlock.connector.type = UnknownType.new()
			block.innerOutputBlock.connector.type = UnknownType.new()
			block.inputTypeConnector.value = UnknownType.new()
			block.outputTypeConnector.value = UnknownType.new()
			block.outputConnector.type = UnknownType.new()
			block.outputConnector.value = null
		elif block is FunctionBlock:
			block.arg1Connector.value = null
			block.arg2Connector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is AndBlock:
			block.arg1Connector.value = null
			block.arg2Connector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is OrBlock:
			block.arg1Connector.value = null
			block.arg2Connector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is AndMkBlock:
			block.input1Connector.value = null
			block.input1Connector.type = UnknownType.new()
			block.input2Connector.value = null
			block.input2Connector.type = UnknownType.new()
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is OrLeftBlock:
			block.inputConnector.value = null
			block.inputConnector.type = UnknownType.new()
			block.typeConnector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is OrRightBlock:
			block.inputConnector.value = null
			block.inputConnector.type = UnknownType.new()
			block.typeConnector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
		elif block is NotElimBlock:
			block.resultConnector.type = UnknownType.new()
			block.falseConnector.value = null
			block.typeConnector.value = null
			block.resultConnector.value = null
		elif block is AndElimBlock:
			block.andConnector.value = null
			block.andConnector.type = UnknownType.new()
			block.typeConnector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
			block.innerInputBlock1.connector.type = UnknownType.new()
			block.innerInputBlock2.connector.type = UnknownType.new()
			block.innerOutputBlock.connector.value = null
			block.innerOutputBlock.connector.type = UnknownType.new()
		elif block is OrElimBlock:
			block.orConnector.value = null
			block.orConnector.type = UnknownType.new()
			block.typeConnector.value = null
			block.resultConnector.value = null
			block.resultConnector.type = UnknownType.new()
			block.innerInputBlockl.connector.type = UnknownType.new()
			block.innerInputBlockr.connector.type = UnknownType.new()
			block.innerOutputBlockl.connector.value = null
			block.innerOutputBlockl.connector.type = UnknownType.new()
			block.innerOutputBlockr.connector.value = null
			block.innerOutputBlockr.connector.type = UnknownType.new()
	
	# Assert: we don't ever have two different wires going into an input

	var failed = false

	while !stack.is_empty():
		var cur: Connector = stack.pop_back()
		var block: Block = cur.parentBlock
		
		#assert(cur.value != null) # don't want this ever lol

		# If we have two or more inputs to this connector, be sad
		if (cur.isInput and cur.inConnections.size() != 1) or (!cur.isInput and !cur.inConnections.is_empty()):
			failed = true
			continue
		
		# If we are an output connector, add the target to the stack
		# Output connector values are set when checking input connectors
		if !cur.isInput:
			for target in cur.outConnections:
				if !checked.has(target):
					checked[target] = true
					stack.append(target)
			continue

		# Else we are an input node

		assert(cur.isInput)
		var from = cur.inConnections[0]
		
		var namespaceLegal = false
		var curNamespace = cur.parentBlock.parentNamespace
		while curNamespace != null:
			if curNamespace == from.parentBlock.parentNamespace:
				namespaceLegal = true
				break
			if curNamespace.parentBlock == null:
				break
			curNamespace = curNamespace.parentBlock.parentNamespace
		if !namespaceLegal:
			failed = true
			continue

		if block is InputBlock:
			assert(false) # We only have output nodes in this case
		elif block is OutputBlock:
			assert(from.value != null) # else we would not have popped cur off of the stack
			if from.type.equalTo(cur.type):
				cur.value = from.value
		elif block is ApplicatorBlock:
			if cur == block.argConnector:
				if block.functionConnector.type is UnknownType:
					# If we are checking the argument first, infer the argument type
					cur.type = from.type
					cur.value = from.value
				else:
					# We have a function annotation already.
					# This will type check only if the domain of the function is of the same type as the input.
					assert(block.functionConnector.type is FunctionType)
					if from.type.equalTo(block.functionConnector.type.domain):
						cur.value = from.value
						if !checked.has(block.resultConnector):
							block.resultConnector.value = true # no types allowed. types bad
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			elif cur == block.functionConnector:
				# We are connecting into the function connector.
				# Either we have or have not checked the argument connector.
				# The connection must have come from a function type.
				if from.type is FunctionType:
					# The return type will always be the codomain type of the function type
					assert(!(from.type.codomain is UnknownType))
					assert(!(from.type.domain is UnknownType))
					if block.argConnector.type is UnknownType:
						# We have not yet checked the argument.
						block.argConnector.type = from.type.domain
						block.resultConnector.type = from.type.codomain
						block.functionConnector.type = from.type
						block.functionConnector.value = true # bad type no supper
					else:
						# If we have checked the argument connector, it would have annotated its type
						# We have to update the result connector type, and check that
						if from.type.domain.equalTo(block.argConnector.type):
							block.resultConnector.type = from.type.codomain
							cur.value = from.value
							cur.type = from.type
							if !checked.has(block.resultConnector):
								assert(!(from.type.codomain is TypeType)) # No dependent types lol
								block.resultConnector.value = true # can't return a type
								checked[block.resultConnector] = true
								stack.append(block.resultConnector)
			else:
				assert(false)
		elif block is LambdaBlock:
			assert(cur.type is TypeType)

			if !(from.type is TypeType):
				continue # Lambda blocks must take types as input

			if cur == block.inputTypeConnector:
				cur.value = from.value
				block.innerInputBlock.connector.type = from.value
				if !(block.outputTypeConnector.type is UnknownType):
					block.outputConnector.type = FunctionType.new(block.inputTypeConnector.value, block.outputTypeConnector.value)
					if block.lambdaNamespace.typeCheck() and !checked.has(block.outputConnector):
						block.outputConnector.value = true # can't return a type (no dependent types)
						checked[block.outputConnector] = true
						stack.append(block.outputConnector)
			elif cur == block.outputTypeConnector:
				cur.value = from.value
				block.innerOutputBlock.connector.type = from.value
				block.outputConnector.type = from.value
				if !(block.inputTypeConnector.type is UnknownType):
					block.outputConnector.type = FunctionType.new(block.inputTypeConnector.value, block.outputTypeConnector.value)
					if block.lambdaNamespace.typeCheck() and !checked.has(block.outputConnector):
						block.outputConnector.value = true # can't return a type (no dependent types)
						checked[block.outputConnector] = true
						stack.append(block.outputConnector)
			else:
				assert(false)
		elif block is FunctionBlock:
			assert(cur.type is TypeType)
			if (!from.type is TypeType):
				continue
			cur.value = from.value
			if (block.arg1Connector.value != null and block.arg2Connector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = FunctionType.new(block.arg1Connector.value, block.arg2Connector.value)
					block.resultConnector.type = TypeType.new()
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is AndBlock:
			assert(cur.type is TypeType)
			if (!from.type is TypeType):
				continue
			cur.value = from.value
			if (block.arg1Connector.value != null and block.arg2Connector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = AndType.new(block.arg1Connector.value, block.arg2Connector.value)
					block.resultConnector.type = TypeType.new()
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is OrBlock:
			assert(cur.type is TypeType)
			if (!from.type is TypeType):
				continue
			cur.value = from.value
			if (block.arg1Connector.value != null and block.arg2Connector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = OrType.new(block.arg1Connector.value, block.arg2Connector.value)
					block.resultConnector.type = TypeType.new()
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is AndMkBlock:
			cur.value = from.value
			cur.type = from.type
			if (block.input1Connector.value != null and block.input2Connector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = true
					block.resultConnector.type = AndType.new(block.input1Connector.type, block.input2Connector.type)
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is OrLeftBlock:
			if cur == block.typeConnector and !(from.type is TypeType):
				continue
			cur.value = from.value
			cur.type = from.type
			if (block.inputConnector.value != null and block.typeConnector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = true
					block.resultConnector.type = OrType.new(block.inputConnector.type, block.typeConnector.value)
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is OrRightBlock:
			if cur == block.typeConnector and !(from.type is TypeType):
				continue
			cur.value = from.value
			cur.type = from.type
			if (block.inputConnector.value != null and block.typeConnector.value != null):
				if !checked.has(block.resultConnector):
					block.resultConnector.value = true
					block.resultConnector.type = OrType.new(block.typeConnector.value, block.inputConnector.type)
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
		elif block is NotElimBlock:
			if cur == block.falseConnector:
				if from.type is FalseType:
					cur.value = from.value
					if block.typeConnector.value != null:
						if !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			elif cur == block.typeConnector:
				if from.type is TypeType:
					cur.value = from.value
					block.resultConnector.type = from.value
					if block.falseConnector.value != null:
						if !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			else:
				assert(false)
		elif block is AndElimBlock:
			if cur == block.andConnector:
				if from.type is AndType:
					cur.value = from.value
					cur.type = from.type
					block.innerInputBlock1.connector.type = from.type.type1
					block.innerInputBlock2.connector.type = from.type.type2
					if block.typeConnector.value != null:
						assert(!(block.innerOutputBlock.type is UnknownType))
						assert(!(block.resultConnector.type is UnknownType))
						if block.andNamespace.typeCheck() and !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			elif cur == block.typeConnector:
				if from.type is TypeType:
					cur.value = from.value
					block.resultConnector.type = from.value
					block.innerOutputBlock.connector.type = from.value
					if block.andConnector.value != null:
						assert(!(block.innerInputBlock1.type is UnknownType))
						assert(!(block.innerInputBlock2.type is UnknownType))
						if block.andNamespace.typeCheck() and !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			else:
				assert(false)
		elif block is OrElimBlock:
			if cur == block.orConnector:
				if from.type is OrType:
					cur.value = from.value
					cur.type = from.type
					block.innerInputBlockl.connector.type = from.type.type1
					block.innerInputBlockr.connector.type = from.type.type2
					if block.typeConnector.value != null:
						assert(!(block.innerOutputBlockl.type is UnknownType))
						assert(!(block.innerOutputBlockr.type is UnknownType))
						assert(!(block.resultConnector.type is UnknownType))
						if block.leftNamespace.typeCheck() and block.rightNamespace.typeCheck() and !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			elif cur == block.typeConnector:
				if from.type is TypeType:
					cur.value = from.value
					block.resultConnector.type = from.value
					block.innerOutputBlockl.connector.type = from.value
					block.innerOutputBlockr.connector.type = from.value
					if block.orConnector.value != null:
						assert(!(block.innerInputBlockl.type is UnknownType))
						assert(!(block.innerInputBlockr.type is UnknownType))
						if block.leftNamespace.typeCheck() and block.rightNamespace.typeCheck() and !checked.has(block.resultConnector):
							block.resultConnector.value = true # can't return a type (no dependent types)
							checked[block.resultConnector] = true
							stack.append(block.resultConnector)
			else:
				assert(false)
		else:
			assert(false)

	for block: Block in blocks:
		if block is InputBlock:
			if block.connector.value == null:
				return false
		elif block is OutputBlock:
			if block.connector.value == null:
				return false
		elif block is ApplicatorBlock:
			if block.argConnector.value == null or block.functionConnector.value == null or block.resultConnector.value == null:
				return false
		elif block is LambdaBlock:
			if block.inputTypeConnector.value == null or block.outputTypeConnector.value == null or block.outputConnector.value == null:
				return false
		elif block is FunctionBlock:
			if block.arg1Connector.value == null or block.arg2Connector.value == null or block.resultConnector.value == null:
				return false
		elif block is AndBlock:
			if block.arg1Connector.value == null or block.arg2Connector.value == null or block.resultConnector.value == null:
				return false
		elif block is OrBlock:
			if block.arg1Connector.value == null or block.arg2Connector.value == null or block.resultConnector.value == null:
				return false
		elif block is AndMkBlock:
			if block.input1Connector.value == null or block.input2Connector.value == null or block.resultConnector.value == null:
				return false
		elif block is OrLeftBlock:
			if block.inputConnector.value == null or block.typeConnector.value == null or block.resultConnector.value == null:
				return false
		elif block is OrRightBlock:
			if block.inputConnector.value == null or block.typeConnector.value == null or block.resultConnector.value == null:
				return false
		elif block is NotElimBlock:
			if block.falseConnector.value == null or block.typeConnector.value == null or block.resultConnector.value == null:
				return false
		elif block is AndElimBlock:
			if block.andConnector.value == null or block.typeConnector.value == null or block.resultConnector.value == null:
				return false
		elif block is OrElimBlock:
			if block.orConnector.value == null or block.typeConnector.value == null or block.resultConnector.value == null:
				return false
		else:
			assert(false)
	return !failed
