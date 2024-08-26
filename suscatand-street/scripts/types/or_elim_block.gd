class_name OrElimBlock
extends Block

var orConnector: Connector
var typeConnector: Connector
var resultConnector: Connector

var leftNamespace: Namespace
var rightNamespace: Namespace

var innerInputBlockl: InputBlock
var innerInputBlockr: InputBlock
var innerOutputBlockl: OutputBlock
var innerOutputBlockr: OutputBlock

func _init(parentNamespace_: Namespace):
	orConnector = Connector.new(self, true, false, UnknownType.new())
	typeConnector = Connector.new(self, true, true, TypeType.new())
	resultConnector = Connector.new(self, false, false, UnknownType.new())
	parentNamespace = parentNamespace_
	
	leftNamespace = Namespace.new()
	rightNamespace = Namespace.new()
	leftNamespace.parentBlock = self
	rightNamespace.parentBlock = self
	
	innerInputBlockl = InputBlock.new(leftNamespace, UnknownType.new(), true)
	innerInputBlockr = InputBlock.new(rightNamespace, UnknownType.new(), true)
	innerOutputBlockl = OutputBlock.new(leftNamespace, UnknownType.new())
	innerOutputBlockr = OutputBlock.new(rightNamespace, UnknownType.new())
	
	# Lol this should be in the block initializer oh well
	leftNamespace.blocks.append(innerInputBlockl)
	rightNamespace.blocks.append(innerInputBlockr)
	leftNamespace.blocks.append(innerOutputBlockl)
	rightNamespace.blocks.append(innerOutputBlockr)
	
	subNamespaces.append(leftNamespace)
	subNamespaces.append(rightNamespace)
