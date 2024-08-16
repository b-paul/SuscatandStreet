extends SubViewportContainer

func _can_drop_data(at_position, data):
	return data.item_id == "game_node"

func _drop_data(at_position, data):
	var text = Label.new()
	text.text = data.message
	text.position = at_position
	add_child(text)
