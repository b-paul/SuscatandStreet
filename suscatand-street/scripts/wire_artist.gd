extends Node2D
var color = Color.DODGER_BLUE
var connections: Array[ConnectorNode]
var baked_points: Array[Curve2D]
var intersecting: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func draw_curve(i: int, start: Vector2, end: Vector2, startNormal: Vector2, endNormal: Vector2) -> void:
	var line_width = 10
	var hover_color = Color.BLACK
	var hover_width = 15
	var control_distance = start.distance_to(end) / 2

	var curve = Curve2D.new()
	curve.add_point(start, Vector2(0, 0), startNormal * control_distance)
	curve.add_point(end, endNormal * control_distance)

	baked_points[i] = curve
	if intersecting.find(i) != -1:
		draw_polyline(curve.get_baked_points(), hover_color, hover_width, true)
	draw_polyline(curve.get_baked_points(), color, line_width, true)
	

func _draw() -> void:
	connections = get_parent().connectedNodes
	baked_points.resize(connections.size())
	var start: Vector2 = get_parent().global_position - global_position + Vector2(15,15)
	var startNormal: Vector2 = get_parent().wire_normal
	for i in len(connections):
		var end: Vector2 = connections[i].global_position - global_position + Vector2(15,15)
		var endNormal: Vector2 = connections[i].wire_normal
		draw_curve(i, start,end,startNormal,endNormal)

func _input(event):
	if event is InputEventMouseMotion:
		var new_intersecting: Array[int] = []
		for curve in len(baked_points):
			for i in len(baked_points[curve].get_baked_points()) - 1:
				var start = baked_points[curve].get_baked_points()[i] + global_position
				var end = baked_points[curve].get_baked_points()[i + 1] + global_position
				var diff = end - start
				# Where on the segment is closest to the cursor?
				var t = max(0, min(1, (event.position - start).dot(end - start) / diff.length_squared()))
				var closest_point = start + (end - start) * t
				# How far away is it?
				var distance_squared = (event.position - closest_point).length_squared()
				if distance_squared < 100:
					new_intersecting.append(curve)
					break
		if new_intersecting != intersecting:
			intersecting = new_intersecting
			queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
