class_name LambdaBlock
extends Block

var inputType: Type
var outputType: Type
var lambdaNamespace: Namespace

func _init(parentNamespace_: Namespace):
	inputType = UnknownType.new()
	outputType = UnknownType.new()
	lambdaNamespace = Namespace.new()
	lambdaNamespace.parentBlock = self
	lambdaNamespace.blocks.append(InputBlock.new(lambdaNamespace, "x", UnknownType.new()))
	lambdaNamespace.blocks.append(OutputBlock.new(lambdaNamespace, UnknownType.new()))
	parentNamespace = parentNamespace_
