extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	reposition()
	
func reposition():
	var normal = get_parent().get_parent().wire_normal
	match int(sign(normal.x)):
		-1:
			match int(sign(normal.y)):
				-1, 0:
					print("Bottom right")
					set_anchors_and_offsets_preset(PRESET_BOTTOM_RIGHT, 0, 15)
				1:
					print("Top right")
					set_anchors_and_offsets_preset(PRESET_TOP_RIGHT, 0, 15)
		0, 1:
			match int(sign(normal.y)):
				-1, 0:
					print("Bottom left")
					set_anchors_and_offsets_preset(PRESET_BOTTOM_LEFT, 0, 15)
				1:
					print("Top left")
					set_anchors_and_offsets_preset(PRESET_TOP_LEFT, 0, 15)

func set_type_name(type_name: String):
	text = type_name
	reposition()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
