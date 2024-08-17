extends Node2D
var color = Color(0.117647, 0.564706, 1, 1)
var connections: Array[ConnectorNode]
var baked_points: Array[Curve2D]
var intersecting: Array[int]

func _ready():
	z_index = 0

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
	var start: Vector2 = get_parent().global_position - global_position + Vector2(24,24)
	var startNormal: Vector2 = get_parent().wire_normal
	for i in len(connections):
		var end: Vector2 = connections[i].global_position - global_position + Vector2(24,24)
		var endNormal: Vector2 = connections[i].wire_normal
		draw_curve(i, start,end,startNormal,endNormal)

func _input(event):
	if event is InputEventMouseMotion:
		var new_intersecting: Array[int] = []
		for curve in len(baked_points):
			
			var first = baked_points[curve].get_baked_points()[0] + global_position
			var last = baked_points[curve].get_baked_points()[-1] + global_position
			var dist_to_first = (event.position - first).length_squared()
			var dist_to_last = (event.position - last).length_squared()
			if dist_to_first < 400 or dist_to_last < 400:
				continue
			
			for i in len(baked_points[curve].get_baked_points()) - 1:
				var start = baked_points[curve].get_baked_points()[i] + global_position
				var end = baked_points[curve].get_baked_points()[i + 1] + global_position
				var diff = end - start
				# Where on the segment is closest to the cursor?
				var t = max(0, min(1, (event.position - start).dot(end - start) / diff.length_squared()))
				var closest_point = start + (end - start) * t
				# How far away is it?
				var distance_squared = (event.position - closest_point).length_squared()
				if distance_squared < 400:
					new_intersecting.append(curve)
					break
		if new_intersecting != intersecting:
			intersecting = new_intersecting
			queue_redraw()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				if intersecting.size() > 0:
					get_parent().disconnect_node(connections[intersecting[0]])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
