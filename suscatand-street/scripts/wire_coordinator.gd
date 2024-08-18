extends Node2D

var connections: Array = [] # Array[Array[ConnectorNode]]
var baked_points: Array = [] # Array[Array[Curve2D]]
var hovering: Array = [] # Array[Array[int]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func draw_curve(connector: int, connection: int, start: Vector2, end: Vector2, startNormal: Vector2, endNormal: Vector2) -> void:
	var line_width = 10
	var hover_color = Color.BLACK
	var hover_width = 15
	var control_distance = start.distance_to(end) / 2

	var curve = Curve2D.new()
	curve.add_point(start, Vector2(0, 0), startNormal * control_distance)
	curve.add_point(end, endNormal * control_distance)

	baked_points[connector][connection] = curve
	if hovering[connector].find(connection) != -1:
		draw_polyline(curve.get_baked_points(), hover_color, hover_width, true)
	draw_polyline(curve.get_baked_points(), Color(0.117647, 0.564706, 1, 1), line_width, true)

func _draw() -> void:
	var connector_len = len(get_parent().connectors)
	connections.resize(connector_len)
	baked_points.resize(connector_len)
	hovering.resize(connector_len)
	for i in len(get_parent().connectors):
		var connector = get_parent().connectors[i]
		connections[i] = connector.connectedNodes
		baked_points[i] = []
		baked_points[i].resize(connections[i].size())
		var start: Vector2 = connector.global_position - global_position + Vector2(24,24)
		var startNormal: Vector2 = connector.wire_normal
		for j in len(connections[i]):
			var end: Vector2 = connections[i][j].global_position - global_position + Vector2(24,24)
			var endNormal: Vector2 = connections[i][j].wire_normal
			draw_curve(i, j, start, end, startNormal, endNormal)

func _input(event):
	if event is InputEventMouseMotion:
		var prev_hovering = hovering
		hovering = []
		hovering.resize(len(baked_points))
		for connector in len(baked_points):
			hovering[connector] = []
			for curve in len(baked_points[connector]):
				var first = baked_points[connector][curve].get_baked_points()[0] + global_position
				var last = baked_points[connector][curve].get_baked_points()[-1] + global_position
				var dist_to_first = (event.position - first).length_squared()
				var dist_to_last = (event.position - last).length_squared()
				if dist_to_first < 400 or dist_to_last < 400:
					continue
				
				for i in len(baked_points[connector][curve].get_baked_points()) - 1:
					var start = baked_points[connector][curve].get_baked_points()[i] + global_position
					var end = baked_points[connector][curve].get_baked_points()[i + 1] + global_position
					var diff = end - start
					# Where on the segment is closest to the cursor?
					var t = max(0, min(1, (event.position - start).dot(end - start) / diff.length_squared()))
					var closest_point = start + (end - start) * t
					# How far away is it?
					var distance_squared = (event.position - closest_point).length_squared()
					if distance_squared < 400:
						hovering[connector].append(curve)
						break
		if hovering != prev_hovering:
			queue_redraw()
		
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				for i in len(hovering):
					if hovering[i].size() > 0:
						get_parent().connectors[i].disconnect_node(
							connections[i][hovering[i][0]])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	queue_redraw()
