extends VBoxContainer

@export var hint_texts: Array[String] = ["Hint 0", "Hint 1", "Hint 2", "Hint 3"]
var unlocked_hints = []

func _ready():
	setup_hint_boxes()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#size_flags_horizontal = SIZE_EXPAND_FILL
	#size_flags_vertical = SIZE_EXPAND_FILL

func setup_hint_boxes():
	for i in range(hint_texts.size()):
		var hint_box = Control.new()
		hint_box.name = "HintBox" + str(i)
		hint_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hint_box.custom_minimum_size = Vector2(0, 200) 
		add_child(hint_box)
		
		var hint_block = TextureRect.new()
		hint_block.name = "HintBlock"
		hint_block.texture = load("res://assets/hint.jpg")
		hint_block.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		hint_block.expand = true
		hint_block.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		hint_block.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hint_box.add_child(hint_block)
		
		var hint_label = Label.new()
		hint_label.name = "HintLabel"
		hint_label.text = "Click to reveal hint" + str(i)
		hint_label.add_theme_font_size_override("font_size", 28)
		hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hint_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hint_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		hint_box.add_child(hint_label)
		
		hint_block.modulate.a = .69
		
		# Add a button on top to capture clicks
		var button = Button.new()
		button.name = "HintButton"
		button.flat = true
		button.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		button.mouse_entered.connect(_on_HintBlock_hovered.bind(i))
		button.mouse_exited.connect(_on_HintBlock_unhovered.bind(i))
		button.pressed.connect(_on_HintBlock_pressed.bind(i))
		hint_box.add_child(button)

func _on_HintBlock_pressed(hint_index: int):
	if not hint_index in unlocked_hints:
		unlocked_hints.append(hint_index)
		var hint_box = get_node("HintBox" + str(hint_index))
		var hint_block = hint_box.get_node("HintBlock")
		var hint_label = hint_box.get_node("HintLabel")
		
		hint_label.text = hint_texts[hint_index]
		hint_block.modulate.a = 1
		
func _on_HintBlock_hovered(hint_index: int):
	if not hint_index in unlocked_hints:
		var hint_box = get_node("HintBox" + str(hint_index))
		var hint_block = hint_box.get_node("HintBlock")
		
		hint_block.modulate.a = .8

func _on_HintBlock_unhovered(hint_index: int):
	if not hint_index in unlocked_hints:
		var hint_box = get_node("HintBox" + str(hint_index))
		var hint_block = hint_box.get_node("HintBlock")
		
		hint_block.modulate.a = .69

func update_hints(new_hints: Array[String]):
	hint_texts = new_hints as Array[String]
	
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		#custom_minimum_size.x = get_parent().size.x
		queue_sort()

## Override minimum size to be based on content
#func _get_minimum_size() -> Vector2:
	#var min_size = Vector2.ZERO
	#for child in get_children():
		#if child is Control:
			#var child_min_size = child.get_combined_minimum_size()
			#min_size.y += child_min_size.y
			#min_size.x = max(min_size.x, child_min_size.x)
	#return min_size
