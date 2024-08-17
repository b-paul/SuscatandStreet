extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var bigNamespace = Namespace.new()
	var typeA = PrimType.new("A")
	var typef = FunctionType.new(typeA, typeA)
	var typeType = TypeType.new()
	
	var input1 = InputBlock.new(bigNamespace, typeType, typeA)
	var output1 = OutputBlock.new(bigNamespace, typeA)
	
	bigNamespace.blocks.append(input1)
	bigNamespace.blocks.append(output1)
	
	var lambda1 = LambdaBlock.new(bigNamespace)
	
	bigNamespace.blocks.append(lambda1)
	
	input1.connector.make_connection(lambda1.inputTypeConnector)
	input1.connector.make_connection(lambda1.outputTypeConnector)
	
	#lambda1.outputConnector.make_connection(output1.connector)
	
	lambda1.innerInputBlock.connector.make_connection(lambda1.innerOutputBlock.connector)
	lambda1.innerInputBlock.connector.make_connection(output1.connector)
	
	print(bigNamespace.typeCheck())
	#


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
