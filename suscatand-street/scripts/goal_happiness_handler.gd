class_name GoalHappinessHandler extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_happy() -> void:
	get_node("../Box/Sad").visible = false
	get_node("../Box/Happy").visible = true
	
func make_sad() -> void:
	get_node("../Box/Sad").visible = true
	get_node("../Box/Happy").visible = false
