class_name LambdaHandler extends Node

var lambda_namespace: Namespace
var innerInputBlock: GenericBlock
var innerOutputBlock: GenericBlock
var inputScene = load("res://scenes/blocks/Input.tscn")
var goalScene = load("res://scenes/blocks/Goal.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lambda_namespace = Namespace.new()
	var input: GenericBlock = inputScene.instantiate()
	var goal: GenericBlock = goalScene.instantiate()
	innerInputBlock = input
	innerOutputBlock = goal
	var workspace: Control = get_parent().get_node("./Workspace")
	workspace.add_child(input)
	input.position += Vector2(-96-75,-48)
	workspace.add_child(goal)
	goal.position += Vector2(75,-48)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
