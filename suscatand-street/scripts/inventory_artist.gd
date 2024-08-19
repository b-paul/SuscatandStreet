@tool extends Control
var frame_size: Vector2 = Vector2(850,2000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(15,10)
	frame_size -= position
	queue_redraw() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	frame_size[1] = get_viewport().get_visible_rect().size[1] - 20
	frame_size[0] = get_parent().get_parent().size[0] - 30
	queue_redraw()
	
func _draw():
	draw_rect(Rect2(Vector2(0, 0), frame_size), Color(0, 0, 0), false,30)
