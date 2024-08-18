extends VBoxContainer

class_name Graveyard

func can_drop_data(_position, data):
	return data is Dictionary and "draggable_component" in data and data.draggable_component is GenericBlock

func drop_data(_position, data):
	if data is Dictionary and "draggable_component" in data:
		var block = data.draggable_component
		if block is GenericBlock:
			# Remove the block from its current parent
			if block.get_parent():
				block.get_parent().remove_child(block)
			# Delete the block
			block.queue_free()
			print("Block deleted in graveyard")

func _ready():
	# Set up visual cues for the graveyard
	self.modulate = Color(1, 0, 0, 0.5)  # Semi-transparent red
	var label = Label.new()
	label.text = "Graveyard - Drop blocks here to delete"
	add_child(label)
