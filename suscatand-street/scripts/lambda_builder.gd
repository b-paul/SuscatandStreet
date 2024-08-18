class_name LambdaHandler extends Node

var lambda_namespace: Namespace

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lambda_namespace = Namespace.new()
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	var input: GenericBlock = inputScene.instantiate()
	var goal: GenericBlock = goalScene.instantiate()
	var workspace: Control = get_parent().get_node("./Workspace")
	workspace.add_child(input)
	input.position += Vector2(-400,-40)
	workspace.add_child(goal)
	goal.position += Vector2(300,-40)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
