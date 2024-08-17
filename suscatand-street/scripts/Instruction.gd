extends CenterContainer

@export var instrction_text : String = "exists Turtlecat"

# Called when the node enters the scene tree for the first time.
func _ready():
	setup_instruction()

func setup_instruction():
	var task_box = Control.new()
	task_box.name = "Taskbox"
	task_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	task_box.custom_minimum_size = Vector2(0, 400) 
	add_child(task_box)
		
	var task_block = TextureRect.new()
	task_block.name = "TaskBlock"
	task_block.texture = load("res://assets/task.jpg")
	task_block.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST		
	task_block.expand = true
	task_block.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	task_block.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	task_block.modulate.a = .69
	task_box.add_child(task_block)
		
	var task_label = Label.new()
	task_label.name = "TaskLabel"
	task_label.text = instrction_text
	task_label.add_theme_font_size_override("font_size", 36)
	task_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	task_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	task_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	task_box.add_child(task_label)
	
	
func _notification(what):
	if what == NOTIFICATION_RESIZED:
		#custom_minimum_size.x = get_parent().size.x
		queue_sort()
	
