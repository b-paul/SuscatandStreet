class_name GenericBlock extends CenterContainer

@export var value_name: String
@export var block_type: String
@export var i_am_a_block: bool = true 
@export var connectors: Array[ConnectorNode]

func _ready():
	#$Control/Label.text = value_name
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	for connector in $Connectors.get_children():
		connectors.push_back(connector)
	

#drag variables
var dragging: bool = false
var dragStartPos: Vector2

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				dragStartPos = get_global_mouse_position() - global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos
