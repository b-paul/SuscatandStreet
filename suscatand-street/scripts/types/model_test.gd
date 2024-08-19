extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var bigNamespace = Namespace.new()
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	var typeOr1 = OrType.new(typeA, typeB)
	var typeOr2 = OrType.new(typeB, typeA)
	var typeType = TypeType.new()
	
	var input1 = InputBlock.new(bigNamespace, typeOr1, true)
	var input2 = InputBlock.new(bigNamespace, typeType, typeOr2)
	var input3 = InputBlock.new(bigNamespace, typeType, typeA)
	var input4 = InputBlock.new(bigNamespace, typeType, typeB)
	var output1 = OutputBlock.new(bigNamespace, typeOr2)
	bigNamespace.blocks.append(input1)
	bigNamespace.blocks.append(input2)
	bigNamespace.blocks.append(input3)
	bigNamespace.blocks.append(input4)
	bigNamespace.blocks.append(output1)
	
	#input2.connector.make_connection(output1.connector)
	
	var or1 = OrElimBlock.new(bigNamespace)
	bigNamespace.blocks.append(or1)

	input1.connector.make_connection(or1.orConnector)
	input2.connector.make_connection(or1.typeConnector)
	or1.resultConnector.make_connection(output1.connector)
	
	var inOr1 = OrRightBlock.new(or1.leftNamespace)
	var inOr2 = OrLeftBlock.new(or1.rightNamespace)
	or1.leftNamespace.blocks.append(inOr1)
	or1.rightNamespace.blocks.append(inOr2)
	
	input1.connector.make_connection(or1.orConnector)
	input2.connector.make_connection(or1.typeConnector)
	or1.resultConnector.make_connection(output1.connector)
	
	or1.innerInputBlockl.connector.make_connection(inOr1.inputConnector)
	or1.innerInputBlockr.connector.make_connection(inOr2.inputConnector)
	input4.connector.make_connection(inOr1.typeConnector)
	input3.connector.make_connection(inOr2.typeConnector)
	inOr1.resultConnector.make_connection(or1.innerOutputBlockl.connector)
	inOr2.resultConnector.make_connection(or1.innerOutputBlockr.connector)

	print(bigNamespace.typeCheck())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
