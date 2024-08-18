extends Node2D


# Called when the node enters the scene tree for the first time.
func _process(delta) -> void:
	var block = get_parent()
	var label = block.get_child(3)
	var value = get_parent().get_node("Connectors/Connector").value
	if value is Type:
		label.text = value.toString()
	else:
		pass
