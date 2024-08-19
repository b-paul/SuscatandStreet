extends VBoxContainer

@export var slot_size: Vector2 = Vector2(200, 200)
@export var slot_spacing: float = 69
@export var block_paths: Array[String] = ["res://scenes/blocks/Applicator.tscn","res://scenes/blocks/Lambda.tscn"]  
@export var num_slots: int = block_paths.size()
@export var target_container: NodePath = "../../HSplitContainer/PanelContainer"

var drag_preview: Node = null
var target: Node
var dragging: bool = false
var dragged_path: String = ""
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
	for path in block_paths:
		var scene = load(path)
		var blockHolder: Control = CenterContainer.new()
		#blockHolder.size_flags_horizontal = SIZE_SHRINK_CENTER
		var block = scene.instantiate()
		disable_block_drag(block)
		container.add_child(blockHolder)
		blockHolder.add_child(block)
		block.gui_input.connect(_on_block_gui_input.bind(path))

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
	
	if num_slots > block_paths.size():
		slot_container.add_child(create_slot(false))
		

func deepest_lambda_at_mouse(node : Node):
	for child in node.get_children():
		var res = deepest_lambda_at_mouse(child)
		if res:
			return res
	if "i_am_a_block" in node:
		if node.block_type == "lambda":
			if node.get_global_rect().has_point(get_global_mouse_position()):
				return node
	return null

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

func _on_block_gui_input(event: InputEvent, path: String):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# start drag
				dragging = true
				dragged_path = path
				create_drag_preview(path)
			else:
				dragging = false
				# end drag
				if dragged_path != "":
					if target and is_instance_valid(target) and target.get_global_rect().has_point(get_global_mouse_position()):
							var scene = load(dragged_path)
							var new_block = scene.instantiate()
							print("Just created a block:")
							print(new_block)
							var workspace = target.get_child(0).get_child(0).get_child(1).get_child(0)
							var possibleLambda = deepest_lambda_at_mouse(workspace)
							if possibleLambda:
								possibleLambda.get_node("Workspace").add_child(new_block)
							else:
								workspace.add_child(new_block)
							target.get_child(0).get_child(0).init_connectors()
							target.get_child(0).render_game_state()
							new_block.global_position = get_global_mouse_position() - new_block.size / 2
					
					drag_preview.queue_free()
					drag_preview = null
					dragged_path = ""

func create_drag_preview(path: String):
	var scene = load(path)
	drag_preview = scene.instantiate()
	drag_preview.z_index = 69
	target.get_child(1).add_child(drag_preview)
	drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if drag_preview:
			drag_preview.global_position = get_global_mouse_position() - drag_preview.size / 2
