extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	var typeC = PrimType.new("C")
	var fAB = FunctionType.new(typeA, typeB)
	var fBA = FunctionType.new(typeB, typeA)
	var fABC = FunctionType.new(fAB,typeC)
	var fBAC = FunctionType.new(fBA,typeC)

	
	var input1 = inputScene.instantiate()
	workspace.add_child(input1)
	input1.connectors[0].type = TypeType.new()
	input1.connectors[0].value = typeA
	input1.connectors[0].display_type_name()
	input1.global_position = Vector2(200,200)
	
	var input2 = inputScene.instantiate()
	workspace.add_child(input2)
	input2.connectors[0].type = TypeType.new()
	input2.connectors[0].value = typeB
	input2.connectors[0].display_type_name()
	input2.global_position = Vector2(500,200)
	
	var input3 = inputScene.instantiate()
	workspace.add_child(input3)
	input3.connectors[0].type = TypeType.new()
	input3.connectors[0].value = typeC
	input3.connectors[0].display_type_name()
	input3.global_position = Vector2(800,200)
	
	#var input4 = inputScene.instantiate()
	#workspace.add_child(input4)
	#input4.connectors[0].type = typeA
	#input4.connectors[0].value = true
	#input4.connectors[0].display_type_name()
	#input4.global_position = Vector2(800,200)
	
	var inputfABC = inputScene.instantiate()
	workspace.add_child(inputfABC)
	inputfABC.connectors[0].type = fABC
	inputfABC.connectors[0].value = true
	inputfABC.connectors[0].display_type_name()
	inputfABC.global_position = Vector2(200,800)
	
	var output1 = goalScene.instantiate()
	workspace.add_child(output1)
	output1.connectors[0].type = fBAC
	output1.connectors[0].display_type_name()
	output1.global_position = Vector2(1500,800)
	
	
	
	
	
