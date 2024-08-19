@tool extends CenterContainer

@export var width: int = 500
@export var height: int = 250
const min_width: int = 462
const min_height: int = 216
var dragging: bool = false
var dragStartPos: Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update() # Replace with function body.

func update() -> void:
	if width < min_width:
		width = min_width
	if height < min_height:
		height = min_height
	var lambda = get_parent().get_parent()
	lambda.size = Vector2(width, height)
	lambda.get_node("LambdaArtist").outer_rect_size = Vector2(width, height)
	self.position = Vector2(width/2 - 45, height/2 - 45)
	lambda.get_node("Connectors/InType").position = Vector2(19-width/2, height/2 - 21)
	lambda.get_node("Connectors/OutType").position = Vector2(245-width/2, height/2 - 21)
	lambda.get_node("Connectors/OutFunction").position = Vector2(width/2 - 21, -24)
	
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				dragStartPos = get_global_mouse_position() - global_position
			else:
				dragging = false
				update()

func _input(event):
	if event is InputEventMouseMotion and dragging:
		global_position = get_global_mouse_position() - dragStartPos
		var top_left: Vector2 = get_parent().get_parent().global_position
		var bottom_right: Vector2 = global_position + Vector2(45,45)
		var dimensions: Vector2 = bottom_right - top_left
		width = dimensions[0]
		height = dimensions[1]
		update()
		accept_event()
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
