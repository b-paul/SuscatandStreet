extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	var applicatorScene = load("res://scenes/blocks/Applicator.tscn")
	
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	var typeC = PrimType.new("C")
	var typeBA = FunctionType.new(typeB, typeA)
	
	var input1: GenericBlock = inputScene.instantiate()
	var input2: GenericBlock = inputScene.instantiate()
	var input3: GenericBlock = inputScene.instantiate()

	var inputa = inputScene.instantiate()
	var inputb = inputScene.instantiate()
	var inputc = inputScene.instantiate()
	var inputba = inputScene.instantiate()
		
	var output = goalScene.instantiate()
	
	workspace.add_child(input1)
	workspace.add_child(input2)
	workspace.add_child(input3)
	workspace.add_child(inputa)
	workspace.add_child(inputb)
	workspace.add_child(inputc)	
	workspace.add_child(inputba)
	workspace.add_child(output)
	
	input1.connectors[0].type = FunctionType.new(typeC, FunctionType.new(typeC, typeB))
	input1.connectors[0].value = true
	input1.connectors[0].display_type_name()
	
	input2.connectors[0].type = FunctionType.new(FunctionType.new(typeB, typeA), typeC)
	input2.connectors[0].value = true
	input2.connectors[0].display_type_name()
	
	input3.connectors[0].type = FunctionType.new(typeB, typeA)
	input3.connectors[0].value = true
	input3.connectors[0].display_type_name()
	
	inputa.connectors[0].type = TypeType.new()
	inputa.connectors[0].value = typeA
	inputa.connectors[0].display_type_name()
	
	inputb.connectors[0].type = TypeType.new()
	inputb.connectors[0].value = typeB
	inputb.connectors[0].display_type_name()
	
	inputc.connectors[0].type = TypeType.new()
	inputc.connectors[0].value = typeB
	inputc.connectors[0].display_type_name()
	
	inputba.connectors[0].type = TypeType.new()
	inputba.connectors[0].value = typeBA
	inputba.connectors[0].display_type_name()

	output.connectors[0].type = typeA
	output.connectors[0].display_type_name()
