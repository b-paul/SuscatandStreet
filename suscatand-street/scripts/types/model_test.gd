extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var bigNamespace = Namespace.new()
	var typeA = PrimType.new("A")
	
	var input1 = InputBlock.new(bigNamespace, typeA, true)
	var output1 = OutputBlock.new(bigNamespace, typeA)
	
	bigNamespace.blocks.append(input1)
	bigNamespace.blocks.append(output1)

	input1.connector.make_connection(output1.connector)
	#input1.connector.make_connection(lambda1.outputTypeConnector)

	print(input1.connector.value, output1.connector.value)	
	print(bigNamespace.typeCheck())
	print(input1.connector.value, output1.connector.value)		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
