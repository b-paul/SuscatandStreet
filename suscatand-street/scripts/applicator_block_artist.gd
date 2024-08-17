extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw():
	# Define the triangle vertices
	var points = PackedVector2Array([Vector2(100, 0), Vector2(0, 200), Vector2(200, 200)])

	# Draw the white triangle
	draw_polygon(points, [Color(1, 1, 1)])

	# Draw the black border
	draw_line(points[0], points[1], Color(0, 0, 0), 10)
	draw_line(points[1], points[2], Color(0, 0, 0), 10)
	draw_line(points[2], points[0], Color(0, 0, 0), 10)
