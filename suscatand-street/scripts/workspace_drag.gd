extends Panel

func _can_drop_data(at_position, data):
	return "draggable_component" in data and data.name_space == "0"

func _drop_data(at_position, data):
	#var text = Label.new()
	#text.text = data.message
	#text.position = at_position
	#add_child(text)
	
	var new_item = data.new_item
	new_item.position = at_position
	add_child(new_item)
	# Delete the original item
	if "original_item" in data and is_instance_valid(data.original_item):
		data.original_item.queue_free()
