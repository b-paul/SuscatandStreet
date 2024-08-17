# Item.gd (attached to your item scene)
extends Node2D

signal connection_started(item, circle_index)
signal connection_ended(item, circle_index)

var circles = []
var is_connecting = false
var connection_start_circle = -1

func _ready():
	# Assuming your circles are direct children of the item
	circles = get_children().filter(func(child): return child is CollisionShape2D and child.shape is CircleShape2D)
	
	for i in range(circles.size()):
		var circle = circles[i]
		circle.input_event.connect(_on_circle_input_event.bind(i))

func _on_circle_input_event(_viewport, event, _shape_idx, circle_index):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_connecting:
			is_connecting = true
			connection_start_circle = circle_index
			emit_signal("connection_started", self, circle_index)
		else:
			is_connecting = false
			emit_signal("connection_ended", self, circle_index)

func get_circle_position(index):
	return circles[index].global_position
