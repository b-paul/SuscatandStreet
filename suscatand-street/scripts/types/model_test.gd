extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var bigNamespace = Namespace.new()
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	
	var input1 = InputBlock.new(bigNamespace, typeA, true)
	var input2 = InputBlock.new(bigNamespace, typeB, true)
	var output1 = OutputBlock.new(bigNamespace, typeB)
	bigNamespace.blocks.append(input1)
	bigNamespace.blocks.append(input2)
	bigNamespace.blocks.append(output1)
	
	input2.connector.make_connection(output1.connector)

	print(bigNamespace.typeCheck())



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
