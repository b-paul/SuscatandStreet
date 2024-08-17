extends CenterContainer

@export var value_name: String
@export var type_name: String
@export var output: String
@export var outputReady : bool = false

	
# Called when the node enters the scene tree for the first time.

#func _init(v: String, t: String):
	#value_name = v
	#type_name = t

# store input info
var inputs = {
	"functionInput": {"type": "", "provided": false, "node": null},
	"regularInput": {"type": "", "provided": false, "node": null}
}

var dragging: bool = false
var dragStartPos: Vector2
@export var stickyNodes: Array 
var stickyNodeStartPositions: Array

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if inputs.functionInput.provided and inputs.regularInput.provided:
		# output = function apply to input
		outputReady = true

func _ready():
	#$Control/Label.text = value_name
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	stickyNodes = [$Control/Node2D/out/Wire/EndBox]
	stickyNodeStartPositions = [$Control/Node2D/out/Wire/EndBox.global_position]

	# init input type
	inputs.functionInput.type = "function"
	inputs.functionInput.node = $Control/Node2D/WireAcceptorFunc
	
	inputs.regularInput.type = "any"
	inputs.regularInput.node = $Control/Node2D/WireAcceptor
	
	if inputs.functionInput.node != null:
		if inputs.functionInput.node.is_wire_acceptor:
			inputs.functionInput.provided = true
		#functionInput.connect("wire_connected", Callable(self, "_on_function_input_connected"))
	if inputs.regularInput.node != null:
		if inputs.functionInput.node.is_wire_acceptor:
			inputs.regularInput.provided = true
		#regularInput.connect("wire_connected", Callable(self, "_on_regular_input_connected"))

#func _on_function_input_connected(wire_data):
	#inputs.functionInput.provided = true
#
#func _on_regular_input_connected(wire_data):
	#inputs.regularInput.provided = true

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				dragStartPos = get_global_mouse_position() - global_position
				stickyNodeStartPositions = []
				for stickyNode in stickyNodes:
					stickyNodeStartPositions.push_back(stickyNode.global_position)
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos
		for i in range(stickyNodes.size()):
			if stickyNodes[i].isSticky:
				stickyNodes[i].global_position = stickyNodeStartPositions[i]
		update_connected_nodes(inputs.functionInput.node)
		update_connected_nodes(inputs.regularInput.node)
		
func update_connected_nodes(node):
	if node != null:
		for connectedNode in node.connectedNodes:
			node.connectedDragStartPositions.push_back(get_global_mouse_position() - connectedNode.global_position)
		for i in range(node.connectedNodes.size()):
			node.connectedNodes[i].global_position = get_global_mouse_position() - node.connectedDragStartPositions[i]
