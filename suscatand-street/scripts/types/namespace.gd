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
			block.innerInputBlock.value = UnknownType.new()
			block.innerOutputBlock.value = UnknownType.new()
			block.outputConnector.type = UnknownType.new()
			block.innerInputBlock.value = null
			block.innerOutputBlock.value = null
			block.outputConnector.value = null
	
	# Assert: we don't ever have two different wires going into an input

	while !stack.is_empty():
		var cur: Connector = stack.pop_back()
		var block: Block = cur.parentBlock
		
		assert(cur.value != null) # don't want this ever lol

		# If we have two or more inputs to this connector, be sad
		if (cur.isInput and cur.inConnections.size() != 1) or (!cur.isInput and !cur.inConnections.is_empty()):
			continue
		
		# If we are an output connector, add the target to the stack
		# Output connector values are set when checking input connectors
		if !cur.isInput:
			for target in cur.outConnections:
				if !checked.has(target):
					checked[block.resultConnector] = true
					stack.append(block.resultConnector)
			continue

		# Else we are an input node
		assert(cur.isInput)
		var from = cur.inConnections[0]
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
				else:
					# We have a function annotation already.
					# This will type check only if the domain of the function is of the same type as the input.
					assert(block.functionConnector.type is FunctionType)
					if cur.type.equalTo(block.functionConnector.type.domain):
						if !checked.has(block.resultConnector):
							block.resultConnector.value = cur.value
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
					else:
						# If we have checked the argument connector, it would have annotated its type
						# We have to update the result connector type, and check that 
						block.resultConnector.type = from.type.codomain
						if from.type.domain.equalTo(block.argConnector.type):
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
					if block.lambdaNamespace.typeCheck() and !checked.has(block.resultConnector):
						block.resultConnector.value = true # can't return a type (no dependent types)
						checked[block.resultConnector] = true
						stack.append(block.resultConnector)
			elif cur == block.outputTypeConnector:
				cur.value = from.value
				block.innerOutputBlock.connector.type = from.value
				block.outputConnector.type = from.value
				if !(block.inputTypeConnector.type is UnknownType):
					if block.lambdaNamespace.typeCheck() and !checked.has(block.resultConnector):
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
		else:
			assert(false)
	return true
