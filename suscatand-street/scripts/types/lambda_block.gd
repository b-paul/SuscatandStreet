class_name LambdaBlock
extends Block

var inputTypeConnector: Connector
var outputTypeConnector: Connector
var outputConnector: Connector
var lambdaNamespace: Namespace
var innerInputBlock: InputBlock
var innerOutputBlock: OutputBlock

func _init(parentNamespace_: Namespace):
	inputTypeConnector = Connector.new(self, true, true, TypeType.new())
	outputTypeConnector = Connector.new(self, true, true, TypeType.new())
	outputConnector = Connector.new(self, false, false, UnknownType.new())
	inputTypeConnector.value = UnknownType.new()
	outputTypeConnector.value = UnknownType.new()
	lambdaNamespace = Namespace.new()
	lambdaNamespace.parentBlock = self
	innerInputBlock = InputBlock.new(lambdaNamespace, UnknownType.new(), true)
	innerOutputBlock = OutputBlock.new(lambdaNamespace, UnknownType.new())
	lambdaNamespace.blocks.append(innerInputBlock)
	lambdaNamespace.blocks.append(innerOutputBlock)
	parentNamespace = parentNamespace_
