class_name WireEnd extends Control

#func make_drag_data():
	#return {draggable_component = true, component_type = "generic", name_space = "0", path = ""}
#
#func _get_drag_data(_position):
#
	#var preview = CenterContainer.new()
	#var data = make_drag_data()
	#var duped = self.duplicate()
#
	#duped.z_index = 60
	#preview.add_child(duped)
#
	#set_drag_preview(preview)
	#self.queue_free()
#
	## Add a reference to the original item
	#data.original_item = self
	#data.new_item = self.duplicate()
	#
	#return data
	
var dragging: bool = false
var just_dropped: bool = false
var dragStartPos: Vector2
var originalPos: Vector2
var originalZIndex
@export var isSticky: bool

#const workspace_path: String = "/root/CanvasLayer/HBoxContainer/HSplitContainer/PanelContainer"
const workspace_path: String = "/root"

func _ready():
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	isSticky = false
	originalPos = position
	
func find_wire_acceptors(root_node: Node) -> Array[WireAcceptor]:
	var nodes_of_type: Array[WireAcceptor] = []
	# Recursive function to traverse children
	
	var traverse = func traverse(node: Node, this_function):
		if "is_wire_acceptor" in node:
			nodes_of_type.append(node)
		else:
			for child in node.get_children():
				this_function.call(child, this_function)

	traverse.call(root_node, traverse)
	
	return nodes_of_type
	
func purge_from_acceptors() -> void:
	var workspace = get_node(workspace_path)
	var candidates: Array[WireAcceptor] = find_wire_acceptors(workspace)
	for candidate in candidates:
		candidate.connectedNodes.erase(self)

func is_connectable():
	var workspace = get_node(workspace_path)
	var candidates: Array[WireAcceptor] = find_wire_acceptors(workspace)
	for candidate in candidates:
		#check if the mouse is within the node
		var mouse_pos = candidate.get_local_mouse_position()
		var rect = Rect2(Vector2.ZERO, candidate.size)
		#print("Checking with this rect:")
		#print(rect)
		#print("And this local mouse pos:")
		#print(candidate.get_local_mouse_position())
		if rect.has_point(mouse_pos):
			#print("Valid!")
			#print(rect)
			return [true, candidate]
	return [false, null]
	

func _gui_input(event):
	if event is InputEventMouseButton:
		print("input!")
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("click on free wire end")
			if event.pressed and not dragging and not just_dropped:
				dragging = true
				dragStartPos = get_global_mouse_position() - global_position
				#originalPos = global_position
				originalZIndex = z_index
			if event.pressed and just_dropped:
				just_dropped = false
				

func _input(event: InputEvent):
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos
		z_index = 60
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			print("global click!")
			if event.pressed and dragging:
							dragging = false
							just_dropped = true
							z_index = originalZIndex
							var connectable = is_connectable()
							if connectable[0]:
								var accepting_node: WireAcceptor = connectable[1]
								purge_from_acceptors()
								accepting_node.accept(self)

							else:
								purge_from_acceptors()
								position = originalPos
								z_index = originalZIndex
								isSticky = false
		
		
