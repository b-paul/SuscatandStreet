class_name Wire extends Node2D

var start: Vector2
var startNormal: Vector2 = Vector2.RIGHT
var end: Vector2
var endNormal: Vector2 = Vector2.LEFT
var color = Color.DODGER_BLUE
var solid : bool = true

func _ready() -> void:
	# Initialize start and end points in _ready
	start = $StartBox.position + Vector2(25,25)
	end = $EndBox.position + Vector2(25,25)
	queue_redraw()  # Request an initial draw

func _draw() -> void:
	# Define the line color and width
	var line_width = 10
	var control_distance = start.distance_to(end) / 2

	var curve = Curve2D.new()
	endNormal = (start - end).normalized()
	curve.add_point(start, Vector2(0, 0), startNormal * control_distance)
	curve.add_point(end, endNormal * control_distance)

	var curve_points = curve.tessellate()
	draw_polyline(curve.get_baked_points(), color, line_width, solid)

func _process(delta: float) -> void:
	# Update start and end points dynamically
	start = $StartBox.position + Vector2(25,25)
	end = $EndBox.position + Vector2(25,25)
	# solid = get to parent.outputReady
	queue_redraw()  # Request a redraw whenever the points change
