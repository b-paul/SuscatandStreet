extends CenterContainer

@export var value_name: String
@export var type_name: String

# Called when the node enters the scene tree for the first time.

#func _init(v: String, t: String):
	#value_name = v
	#type_name = t


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


var dragging: bool = false
var dragStartPos: Vector2
@export var stickyNodes: Array 
var stickyNodeStartPositions: Array

func _ready():
	#$Control/Label.text = value_name
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	stickyNodes = [$Control/Wire/EndBox]
	stickyNodeStartPositions = [$Control/Wire/EndBox.global_position]
	

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
