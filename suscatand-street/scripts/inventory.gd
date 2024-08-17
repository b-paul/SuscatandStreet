extends VBoxContainer

@export var slot_size: Vector2 = Vector2(200, 200)
@export var slot_spacing: float = 69
@export var block_UIDs: Array[String] = ["uid://hg2qkq7cb6uc","uid://b2p2wnjkqxitw", "uid://c34gd6iom0l2t", "uid://bdjteonbibkwu"]  
@export var num_slots: int = block_UIDs.size() + 1
var drag_data = null

func _ready():
	setup_slots()
	
func load_blocks(container):
	for UID in block_UIDs:
		var id: int = ResourceUID.text_to_id(UID)
		if ResourceUID.has_id(id):
			var path = load(ResourceUID.get_id_path(id))
			var block = path.instantiate()
			container.add_child(block)

func setup_slots():
	var scroll_container = ScrollContainer.new()
	scroll_container.size_flags_horizontal = SIZE_EXPAND_FILL
	scroll_container.size_flags_vertical = SIZE_EXPAND_FILL
	add_child(scroll_container)

	var slot_container = VBoxContainer.new()
	slot_container.size_flags_horizontal = SIZE_EXPAND_FILL
	slot_container.add_theme_constant_override("separation", slot_spacing)
	scroll_container.add_child(slot_container)

	load_blocks(slot_container)
		
	if num_slots > block_UIDs.size():
		slot_container.add_child(create_slot(block_UIDs.size()))
		

func create_slot(index: int) -> Panel:
	var slot = Panel.new()
	slot.custom_minimum_size = slot_size
	slot.size_flags_horizontal = SIZE_SHRINK_CENTER
	
	slot.gui_input.connect(_on_slot_gui_input.bind(slot))
	
	return slot

func add_block_to_slot(block: Node, slot: Panel):
	if slot.get_child_count() > 0:
		slot.get_child(0).queue_free()
	
	slot.add_child(block)
	
	# Adjust the size of the block to fit the slot
	block.scale = Vector2.ONE * min(slot_size.x / block.size.x, slot_size.y / block.size.y)

func _on_slot_gui_input(event: InputEvent, slot: Panel):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start drag
				drag_data = {"origin": slot, "content": slot.get_child(0) if slot.get_child_count() > 0 else null}
			else:
				# End drag
				if drag_data:
					if drag_data["origin"] != slot:
						# Swap content
						var temp = slot.get_child(0) if slot.get_child_count() > 0 else null
						if drag_data["content"]:
							drag_data["origin"].remove_child(drag_data["content"])
							add_block_to_slot(drag_data["content"], slot)
						if temp:
							slot.remove_child(temp)
							add_block_to_slot(temp, drag_data["origin"])
						
					drag_data = null

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if drag_data:
			# Update drag visual TODO
			pass

#func update_blocks_array():
	#block_UIDs.clear()
	#var slot_container = get_node("ScrollContainer/VBoxContainer")
	#for slot in slot_container.get_children():
		#if slot.get_child_count() > 0:
			#block_UIDs.append(slot.get_child(0))


#func add_new_block(block: String):
	#block_UIDs.append(block)
	#var slot_container = get_node("ScrollContainer/VBoxContainer")
	#for slot in slot_container.get_children():
		#if slot.get_child_count() == 0:
			#add_block_to_slot(block, slot)
			#return
	#print("No empty slots available")
