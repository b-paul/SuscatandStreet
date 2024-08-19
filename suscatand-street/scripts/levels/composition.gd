extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	var typeC = PrimType.new("C")

	
	var input1 = inputScene.instantiate()
	workspace.add_child(input1)
	input1.connectors[0].type = TypeType.new()
	input1.connectors[0].value = typeA
	input1.connectors[0].display_type_name()
	
	var input2 = inputScene.instantiate()
	workspace.add_child(input2)
	input2.connectors[0].type = TypeType.new()
	input2.connectors[0].value = typeC
	input2.connectors[0].display_type_name()
	
	var inputfAB = inputScene.instantiate()
	workspace.add_child(inputfAB)
	inputfAB.connectors[0].type = FunctionType.new(typeA, typeB)
	inputfAB.connectors[0].value = true
	inputfAB.connectors[0].display_type_name()
	
	var inputfBC = inputScene.instantiate()
	workspace.add_child(inputfBC)
	inputfBC.connectors[0].type = FunctionType.new(typeB, typeC)
	inputfBC.connectors[0].value = true
	inputfBC.connectors[0].display_type_name()
	
	var output1 = goalScene.instantiate()
	workspace.add_child(output1)
	output1.connectors[0].type = FunctionType.new(typeA, typeC)
	output1.connectors[0].display_type_name()
	
	input1.global_position = Vector2(200,200)
	input2.global_position = Vector2(500,200)
	inputfAB.global_position = Vector2(200,500)
	inputfBC.global_position = Vector2(500,500)
	output1.global_position = Vector2(800,350)
	
	
	
	
	
