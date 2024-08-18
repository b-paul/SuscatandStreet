class_name GenericBlock extends CenterContainer

@export var value_name: String
@export var block_type: String
@export var i_am_a_block: bool = true 
@export var connectors: Array[ConnectorNode]
@export var dragging_enabled: bool = true

var dragging: bool = false
var dragStartPos: Vector2
var originalPos: Vector2


func _ready():
	#$Control/Label.text = value_name
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))
	for connector in $Connectors.get_children():
		connectors.push_back(connector)

func _gui_input(event):
	if not dragging_enabled:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				originalPos = global_position
				dragStartPos = get_global_mouse_position() - global_position
			else:
				dragging = false
				var landing_spot = find_landing_spot()
				if landing_spot:
					position = landing_spot.get_local_mouse_position() - size / 2
				else:
					global_position = originalPos
	elif event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() - dragStartPos

func find_landing_spot() -> Node:
	var mouse_pos = get_global_mouse_position()
	var panel_container = get_node_or_null("../../../../../")
	var graveyard = get_node_or_null("../../../../../../InventoryContainer/Graveyard")
	
	#var panel_container = get_node_or_null("/root/CanvasLayer/HBoxContainer/HSplitContainer/PanelContainer")
	#var graveyard = get_node_or_null("/root/CanvasLayer/HBoxContainer/InventoryContainer/Graveyard")
	
	print("checking")
	print(panel_container)
	print(graveyard)
	
	if panel_container and panel_container.get_global_rect().has_point(mouse_pos):
		return panel_container
	elif graveyard and graveyard.get_global_rect().has_point(mouse_pos):
		queue_free()  
		return null
	return null
