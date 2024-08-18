extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	var input1: GenericBlock = inputScene.instantiate()
	var input2: GenericBlock = inputScene.instantiate()
	var goal: GenericBlock = goalScene.instantiate()
	workspace.add_child(input1)
	workspace.add_child(input2)
	workspace.add_child(goal)
	input1.position = Vector2(400,400)
	input2.position = Vector2(400,800)
	goal.position = Vector2(1200,600)
	var typeA = PrimType.new("A")
	var typeB = PrimType.new("B")
	var typefAB = FunctionType.new(typeA, typeB)
	var typeBigF = FunctionType.new(typeA,typefAB)
	input1.connectors[0].type = typeA
	input1.connectors[0].display_type_name()
	input2.connectors[0].type = typeBigF
	input2.connectors[0].display_type_name()
	goal.connectors[0].type = typeB
	goal.connectors[0].display_type_name()
