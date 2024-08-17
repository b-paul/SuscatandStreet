extends Node2D

var start: Vector2
var end: Vector2

func _ready() -> void:
	# Initialize start and end points in _ready
	start = $StartBox.position + Vector2(25,25)
	end = $EndBox.position + Vector2(25,25)
	queue_redraw()  # Request an initial draw

func _draw() -> void:
	# Define the line color and width
	var line_color = Color.WHITE
	var line_width = 2
	draw_line(start, end, line_color, line_width)

func _process(delta: float) -> void:
	# Update start and end points dynamically
	start = $StartBox.position + Vector2(25,25)
	end = $EndBox.position + Vector2(25,25)
	queue_redraw()  # Request a redraw whenever the points change
