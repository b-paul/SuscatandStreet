extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var block = get_parent()
	var label = block.get_child(3)
	label.text = block.value_name
