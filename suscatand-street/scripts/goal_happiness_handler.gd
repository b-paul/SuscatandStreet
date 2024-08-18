class_name GoalHappinessHandler extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_happy() -> void:
	get_parent().get_child(0).get_child(0).visible = false
	get_parent().get_child(0).get_child(1).visible = true
	
func make_sad() -> void:
	get_parent().get_child(0).get_child(0).visible = true
	get_parent().get_child(0).get_child(1).visible = false
