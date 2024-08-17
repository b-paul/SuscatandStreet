extends Node2D
var color = Color.DODGER_BLUE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func draw_curve(start: Vector2, end: Vector2, startNormal: Vector2, endNormal: Vector2) -> void:
	var line_width = 10
	var control_distance = start.distance_to(end) / 2

	var curve = Curve2D.new()
	curve.add_point(start, Vector2(0, 0), startNormal * control_distance)
	curve.add_point(end, endNormal * control_distance)

	var curve_points = curve.tessellate()
	draw_polyline(curve.get_baked_points(), color, line_width, true)
	

func _draw() -> void:
	var connections: Array[ConnectorNode] = get_parent().connectedNodes
	var start: Vector2 = get_parent().position
	var startNormal: Vector2 = get_parent().wire_normal
	for node in connections:
		var end: Vector2 = node.position
		var endNormal: Vector2 = node.wire_normal
		draw_curve(start,end,startNormal,endNormal)

	# Define the line color and width
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
