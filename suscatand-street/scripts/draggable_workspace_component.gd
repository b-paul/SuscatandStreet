extends Control

func make_drag_data():
	return {draggable_component = true, component_type = "generic", name_space = "0", path = ""}

func _get_drag_data(_position):

	var preview = CenterContainer.new()
	var data = make_drag_data()
	var duped = self.duplicate()

	duped.z_index = 60
	preview.add_child(duped)

	set_drag_preview(preview)
	self.queue_free()

	# Add a reference to the original item
	data.original_item = self
	data.new_item = self.duplicate()
	
	return data
