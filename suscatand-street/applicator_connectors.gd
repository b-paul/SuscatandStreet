extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Input.wire_normal = Vector2(-2,-1).normalized()
	$Output.wire_normal = Vector2(2,-1).normalized()
	$Function.wire_normal = Vector2(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
