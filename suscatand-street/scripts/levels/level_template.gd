extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
