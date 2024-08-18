extends VBoxContainer

@export var slot_size: Vector2 = Vector2(200, 200)
@export var slot_spacing: float = 69
#@export var block_UIDs: Array[String] = ["uid://dmcxo8mf0s5fr","uid://b2p2wnjkqxitw", "uid://c0uo6afj7i45f", "uid://bdjteonbibkwu"]
@export var block_UIDs: Array[String] = ["uid://b2p2wnjkqxitw"]  
@export var num_slots: int = block_UIDs.size()
@export var target_container: NodePath = "../../HSplitContainer/PanelContainer"

var drag_preview: Node = null
var dragged_uid: String = ""
var target: Node

func _ready():
	setup_slots()
	setup_target()
	
func setup_target():
	if target_container.is_empty():
		push_warning("Target container path is not set.")
	else:
		target = get_node_or_null(target_container)
		if not target:
			push_error("Target container not found.")

func load_blocks(container):
	for UID in block_UIDs:
		var id: int = ResourceUID.text_to_id(UID)
		if ResourceUID.has_id(id):
			var path = load(ResourceUID.get_id_path(id))
			var block = path.instantiate()
			disable_block_drag(block)		
			container.add_child(block)
			block.gui_input.connect(_on_block_gui_input.bind(UID))
			print("Connected gui_input for block with UID:", UID)
			
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
		slot_container.add_child(create_slot(false))
		

func create_slot(trans: bool) -> Panel:
	var slot = Panel.new()
	slot.custom_minimum_size = slot_size
	slot.size_flags_horizontal = SIZE_SHRINK_CENTER
	
	if trans:
		var style_box = StyleBoxFlat.new()
		style_box.set_bg_color(Color(0, 0, 0, 0))
		slot.add_theme_stylebox_override("panel", style_box)
	
	return slot


func disable_block_drag(block: Node):
	block.dragging_enabled = false
	block.dragging = false
	block.dragStartPos = Vector2.ZERO
	for c in block.get_child(0).get_children():
		c.wire_enabled = false

func _on_block_gui_input(event: InputEvent, uid: String):
	print("_on_block_gui_input called with UID:", uid)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# start drag
				dragged_uid = uid
				create_drag_preview(uid)
			else:
				# end drag
				if dragged_uid != "":
					if target and is_instance_valid(target) and target.get_global_rect().has_point(get_global_mouse_position()):
						var id: int = ResourceUID.text_to_id(dragged_uid)
						if ResourceUID.has_id(id):
							var path = load(ResourceUID.get_id_path(id))
							var new_block = path.instantiate()
							print("Just created a block:")
							print(new_block)
							target.get_child(0).get_child(0).get_child(1).get_child(0).add_child(new_block)
							target.get_child(0).get_child(0).init_connectors()
							target.get_child(0).render_game_state()
							new_block.global_position = get_global_mouse_position() - new_block.size / 2
					
					remove_drag_preview()
					dragged_uid = ""

func create_drag_preview(uid: String):
	var id: int = ResourceUID.text_to_id(uid)
	if ResourceUID.has_id(id):
		var path = load(ResourceUID.get_id_path(id))
		drag_preview = path.instantiate()
		drag_preview.modulate.a = 0.69
		get_tree().root.add_child(drag_preview)
		drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2

func remove_drag_preview():
	if drag_preview:
		drag_preview.queue_free()
		drag_preview = null

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if drag_preview:
			drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2
