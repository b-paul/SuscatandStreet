@tool class_name LambdaArtist extends Node2D

# Define the size of the outer rectangle (the frame's outer dimensions)
var outer_rect_size = Vector2(500, 250)

func _draw():
	# Define the size and position of the inner transparent rectangle
	var inner_rect_size = Vector2(outer_rect_size.x - 2 * 50, outer_rect_size.y - 2 * 50)  # 50px border on each side
	var inner_rect_position = Vector2(50, 50)  # Position the inner rect

	# Draw the top part of the frame
	draw_rect(Rect2(Vector2(0, 0), Vector2(outer_rect_size.x, 50)), Color(1, 1, 1))  # Top
	# Draw the bottom part of the frame
	draw_rect(Rect2(Vector2(0, outer_rect_size.y - 50), Vector2(outer_rect_size.x, 50)), Color(1, 1, 1))  # Bottom
	# Draw the left part of the frame
	draw_rect(Rect2(Vector2(0, 50), Vector2(50, inner_rect_size.y)), Color(1, 1, 1))  # Left
	# Draw the right part of the frame
	draw_rect(Rect2(Vector2(outer_rect_size.x - 50, 50), Vector2(50, inner_rect_size.y)), Color(1, 1, 1))  # Right
	
	# Draw the black outline around the entire frame
	draw_rect(Rect2(Vector2(0, 0), outer_rect_size), Color(0, 0, 0), false,10)

	# Draw the inner border (black rectangle around the transparent area)
	draw_rect(Rect2(inner_rect_position, inner_rect_size), Color(0, 0, 0), false,10)
	
func _process(delta):
	queue_redraw()

func _ready():
	queue_redraw()
