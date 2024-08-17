class_name LambdaBlock
extends Block

var inputTypeConnector: Connector
var outputTypeConnector: Connector
var lambdaNamespace: Namespace

func _init(parentNamespace_: Namespace):
	inputTypeConnector = Connector.new(self, true, UnknownType.new())
	outputTypeConnector = Connector.new(self, true, UnknownType.new())
	lambdaNamespace = Namespace.new()
	lambdaNamespace.parentBlock = self
	lambdaNamespace.blocks.append(InputBlock.new(lambdaNamespace, "x", UnknownType.new(), true))
	lambdaNamespace.blocks.append(OutputBlock.new(lambdaNamespace, UnknownType.new()))
	parentNamespace = parentNamespace_
