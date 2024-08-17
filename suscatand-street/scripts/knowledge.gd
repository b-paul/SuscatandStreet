extends VBoxContainer

@export var instruction_text: String = "Monday is a rainy day\n
And I stay inside, letting time pass away\n
Tuesday it is quite the same\n
So I daydream about moments of shame\n
Life goes around and 'round\n
I've stumbled and stopped moving on\n
Turn around and I realized\n
That I have been left behind\n
In a tiny tiny, tiny, tiny cubicle\n
There lives a whiny, whiny, whiny cowardly turtle\n
In 20, 30, 40, 50, 60 years\n
My heart won't die, no matter how hard I try\n
Today is a lonely day\n
I pretend that I really liked it this way\n
Tomorrow will stay the same\n
And I can't even remember your name\n
You're around no more, no more\n
Though this love of mine\n
It just won't stop\n
Nobody-body-body-body to support\n
My heavy, heavy, heavy but empty shell\n
But I'm not lazy, lazy, lazy, lazy anymore\n
Oh darling can't you see\n
I've grown so much more\n
Maybe, maybe, maybe you've forgiven me\n
Oh but darling, darling, darling you have to make sure\n
To stab me, pierce me, hurt me, kill me thoroughly\n
You see my heart won't die though I really tried\n
"

func _ready():
	setup_instruction()

func setup_instruction():
	var knowledge_box = Control.new()
	knowledge_box.name = "KnowledgeBox"
	knowledge_box.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	knowledge_box.custom_minimum_size = Vector2(0, 850) 
	add_child(knowledge_box)
	
	var knowledge_block = TextureRect.new()
	knowledge_block.name = "KnowledgeBlock"
	knowledge_block.texture = load("res://assets/task.jpg")
	knowledge_block.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST        
	knowledge_block.expand = true
	knowledge_block.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	knowledge_block.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	knowledge_block.modulate.a = .69
	knowledge_box.add_child(knowledge_block)
	
	var knowledge_label = Label.new()
	knowledge_label.name = "KnowledgeLabel"
	knowledge_label.text = "\n   New knowledge: \n"
	knowledge_label.add_theme_font_size_override("font_size", 36)
	knowledge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	knowledge_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	knowledge_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	knowledge_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	knowledge_box.add_child(knowledge_label)
	
	var knowledge_details = RichTextLabel.new()
	knowledge_details.name = "KnowledgeDetails"
	knowledge_details.text = instruction_text
	knowledge_details.add_theme_font_size_override("font_size", 23)
	knowledge_details.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	knowledge_details.offset_left = 42
	knowledge_details.offset_top = 130
	knowledge_details.offset_bottom = 20
	knowledge_details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	knowledge_box.add_child(knowledge_details)

func _notification(what):
	if what == NOTIFICATION_RESIZED:
		queue_sort()
