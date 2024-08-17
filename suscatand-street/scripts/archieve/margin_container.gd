extends MarginContainer

func make_drag_data():
	return {item_id = "game_node", message = "test", path = "res://scenes/item.tscn"}

func _get_drag_data(_position):
	var text = Label.new()
	var preview = Control.new()
	var data = make_drag_data()
	text.text = data.message
	preview.add_child(text)
	preview.z_index = 60
	set_drag_preview(preview)
	
	# Add a reference to the original item
	data.original_item = self
	
	return data
