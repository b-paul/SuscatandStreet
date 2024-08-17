extends Control

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
var dragStartPos: Vector2

func _ready():
	focus_mode = FocusMode.FOCUS_ALL
	connect("gui_input", Callable(self, "_on_gui_input"))

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
