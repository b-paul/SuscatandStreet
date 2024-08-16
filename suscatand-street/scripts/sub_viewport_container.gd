extends SubViewportContainer

func _can_drop_data(at_position, data):
	return data.item_id == "game_node"

func _drop_data(at_position, data):
	#var text = Label.new()
	#text.text = data.message
	#text.position = at_position
	#add_child(text)
	
	var item_scene = load(data.path)
	if item_scene:
		var item_instance = item_scene.instantiate()
		item_instance.position = at_position
		add_child(item_instance)
	# Delete the original item
	if "original_item" in data and is_instance_valid(data.original_item):
		data.original_item.queue_free()
