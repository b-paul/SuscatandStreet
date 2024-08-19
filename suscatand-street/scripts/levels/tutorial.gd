extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")

	
	var input1 = inputScene.instantiate()
	workspace.add_child(input1)
	input1.connectors[0].type = typeA
	input1.connectors[0].value = true
	input1.connectors[0].display_type_name()
	
	var input2 = inputScene.instantiate()
	workspace.add_child(input2)
	input2.connectors[0].type = typeB
	input2.connectors[0].value = true
	input2.connectors[0].display_type_name()
	
	var inputfAB = inputScene.instantiate()
	workspace.add_child(inputfAB)
	inputfAB.connectors[0].type = FunctionType.new(typeB, typeA)
	inputfAB.connectors[0].value = true
	inputfAB.connectors[0].display_type_name()
	
	var output1 = goalScene.instantiate()
	workspace.add_child(output1)
	output1.connectors[0].type = typeA
	output1.connectors[0].display_type_name()
	
	input1.global_position = Vector2(200,200)
	input2.global_position = Vector2(200,500)
	inputfAB.global_position = Vector2(200,800)
	output1.global_position = Vector2(800,500)
	
	
	
	
	
