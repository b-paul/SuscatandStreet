extends Node2D


# Called when the node enters the scene tree for the first time.
func _process(delta) -> void:
	var block = get_parent()
	var label: Label = block.get_node("LabelControl/Label")
	var value = get_parent().get_node("Connectors/Output").value
	#if block.block_type == "function":
		#print(value)
	if value is Type:
		var t: String = value.toString()
		label.text = t
		var font: Font = label.get_theme_font("res://assets/lmsans8-regular.otf")
		while font.get_string_size(t, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size"))[0] > 70:
			label.add_theme_font_size_override("font_size",label.get_theme_font_size("font_size")-1)
	else:
		if value == null:
			label.text = ""
