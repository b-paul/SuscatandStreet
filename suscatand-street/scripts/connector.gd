class_name ConnectorNode extends CenterContainer

@export var is_connector_node: bool = true
@export var is_square: bool = false
@export var connectedNodes: Array[ConnectorNode]
@export var wire_normal: Vector2
@export var wire_enabled = true
var type: Type = UnknownType.new()
var value

var dragging_wire: bool = false
var wire_dragged: Wire
var coordinator: ConnectorCoordinator
var controller: BackendCommunicator

func get_type_name() -> String:
	return type.toString()

func display_type_name() -> void:
	set_type_name(get_type_name())

func set_color(color: Color) -> void:
	$ConnectorCircle.modulate = color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connectedNodes = []
	$ConnectorCircle.visible = not is_square
	$ConnectorSquare.visible = is_square

func set_type_name(type_name: String) -> void:
	$Control/Label.set_text(type_name)
	$Control/Label.reposition()

func connect_node(node: ConnectorNode) -> void:
	print("making a connection from" + self.to_string() + "to " + node.to_string())
	connectedNodes.push_back(node)
	print("Checking...")
	controller.render_game_state()

func disconnect_node(node: ConnectorNode) -> void:
	if not node in connectedNodes:
		return
	connectedNodes.erase(node)
	print("Checking...")
	controller.render_game_state()
	#communicate with backend

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _gui_input(event):
	#if coordinator.dragging_wire:
		#return
	if not wire_enabled:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var wire_scene = load("res://scenes/Wire.tscn")
			var wire = wire_scene.instantiate()
			wire_dragged = wire
			add_child(wire)
			wire.position = Vector2(24,24)
			wire.startNormal = wire_normal
			var wire_end: WireEnd = wire.get_child(1)
			wire_end.dragging = true
			dragging_wire = true
			#coordinator.dragging_wire = true
			wire_end.originalZIndex = z_index + 1
			wire_end.dragStartPos = Vector2(25,25)

func find_connectors(root_node: Node) -> Array[ConnectorNode]:
	var nodes_of_type: Array[ConnectorNode] = []
	# Recursive function to traverse children
	
	var traverse = func traverse(node: Node, this_function):
		if "is_connector_node" in node:
			nodes_of_type.append(node)
		else:
			for child in node.get_children():
				this_function.call(child, this_function)

	traverse.call(root_node, traverse)
	
	return nodes_of_type

func attempt_connection_at_mouse() -> void:
	var workspace = get_tree().root.get_child(0)
	var candidates: Array[ConnectorNode] = find_connectors(workspace)
	for candidate in candidates:
		#check if the mouse is within the node
		var mouse_pos = candidate.get_local_mouse_position()
		var rect = Rect2(Vector2.ZERO, candidate.size)
		if rect.has_point(mouse_pos):
			if not candidate == self and not candidate in connectedNodes:
				connect_node(candidate)
				return
	return

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and dragging_wire:
				dragging_wire = false
				#coordinator.dragging_wire = false
				wire_dragged.queue_free()
				attempt_connection_at_mouse()
				accept_event()
