class_name AndElimBlock
extends Block

var andConnector: Connector
var typeConnector: Connector
var resultConnector: Connector

var andNamespace: Namespace

var innerInputBlock1: InputBlock
var innerInputBlock2: InputBlock
var innerOutputBlock: OutputBlock

func _init(parentNamespace_: Namespace):
	andConnector = Connector.new(self, true, false, UnknownType.new())
	typeConnector = Connector.new(self, true, true, TypeType.new())
	resultConnector = Connector.new(self, false, false, UnknownType.new())
	parentNamespace = parentNamespace_
	
	andNamespace = Namespace.new()
	andNamespace.parentBlock = self
	
	innerInputBlock1 = InputBlock.new(andNamespace, UnknownType.new(), true)
	innerInputBlock2 = InputBlock.new(andNamespace, UnknownType.new(), true)
	innerOutputBlock = OutputBlock.new(andNamespace, UnknownType.new())
	
	# Lol this should be in the block initializer oh well
	andNamespace.blocks.append(innerInputBlock1)
	andNamespace.blocks.append(innerInputBlock2)
	andNamespace.blocks.append(innerOutputBlock)
