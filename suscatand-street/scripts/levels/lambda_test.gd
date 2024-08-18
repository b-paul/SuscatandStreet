extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	var lambdaScene = load("res://scenes/blocks/Lambda.tscn")
	var lambda = lambdaScene.instantiate()
	workspace.add_child(lambda)
