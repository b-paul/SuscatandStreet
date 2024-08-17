extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	queue_redraw() # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw():
	draw_rect(Rect2(0, 0, 100, 100), Color(1, 1, 1))
	draw_rect(Rect2(0, 0, 100, 100), Color(0, 0, 0), false, 10)
