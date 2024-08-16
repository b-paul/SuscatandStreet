extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

#@export var modulation := Color(1, 1, 0.5, 1):
	#get:
		#return modulation
	#set(value):
		#modulation = value
		#%TextureRect.modulate = value
#
#func _get_drag_data(_position):
	#var icon = TextureRect.new()
	#var preview = Control.new()
	#icon.texture = %TextureRect.texture
	#icon.position = icon.texture.get_size() * -0.5
	#icon.modulate = modulation
	#preview.add_child(icon)
	#preview.z_index = 60
	#set_drag_preview(preview)
	#return { item_id = "godot_icon", modulation = modulation }
