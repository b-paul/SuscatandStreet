class_name GoalBlock extends CenterContainer

@export var type_name: String
@export var acceptors: Array[WireAcceptor]

# Called when the node enters the scene tree for the first time.

#func _init(v: String, t: String):
	#value_name = v
	#type_name = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var dragging: bool = false
var dragStartPos: Vector2

func _ready():
	#$Control/Label.text = value_name
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	acceptors = [$Control/ColorRect/WireAcceptor]
	

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				dragStartPos = get_global_mouse_position() - global_position
				for acceptor in acceptors:
					acceptor.connectedDragStartPositions = []
					for connectedNode in acceptor.connectedNodes:
						acceptor.connectedDragStartPositions.push_back(get_global_mouse_position() - connectedNode.global_position)
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos
		for acceptor in acceptors:
			for i in range(acceptor.connectedNodes.size()):
				acceptor.connectedNodes[i].global_position = get_global_mouse_position() - acceptor.connectedDragStartPositions[i]
