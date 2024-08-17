extends Node2D

func _ready():
	print("Script is loaded")
	
	# Check if this Node2D is in the scene tree
	if not is_inside_tree():
		print("WARNING: not in the scene tree!")
	
	# Check visibility of this Node2D
	if not visible:
		print("WARNING: not set to visible!")
	
	# Check for Area2D
	var area = find_child("*", false, false) as Area2D
	if area:
		print("Area2D found: ", area.name)
		check_area(area)
	else:
		print("ERROR: No Area2D found as a child!")
	
	# Additional Node2D checks
	print("position: ", position)
	print("z_index: ", z_index)
	print("global_position: ", global_position)

func check_area(area: Area2D):
	# Check Area2D visibility
	if not area.visible:
		print("WARNING: Area2D not set to visible!")
	
	# Check for CollisionShape2D
	var collision_shape = area.find_child("*", false, false) as CollisionShape2D
	if collision_shape:
		print("CollisionShape2D found: ", collision_shape.name)
		check_collision_shape(collision_shape)
	else:
		print("ERROR: No CollisionShape2D found as a child of the Area2D!")
	
	# Check if monitoring and monitorable are enabled
	print("Area2D monitoring: ", area.monitoring)
	print("Area2D monitorable: ", area.monitorable)

func check_collision_shape(collision_shape: CollisionShape2D):
	# Check if the collision shape has a shape assigned
	if collision_shape.shape:
		print("CollisionShape2D has a shape assigned: ", collision_shape.shape.get_class())
	else:
		print("ERROR: CollisionShape2D has no shape assigned!")
	
	# Check if the collision shape is disabled
	if collision_shape.disabled:
		print("WARNING: CollisionShape2D is disabled!")
	
func _draw():
	# Draw a visual representation of the Area2D and CollisionShape2D
	var area = find_child("*", false, false) as Area2D
	if area:
		var collision_shape = area.find_child("*", false, false) as CollisionShape2D
		if collision_shape and collision_shape.shape:
			if collision_shape.shape is CircleShape2D:
				var circle = collision_shape.shape as CircleShape2D
				draw_circle(collision_shape.position, circle.radius, Color(1, 0, 0, 0.5))
			elif collision_shape.shape is RectangleShape2D:
				var rect = collision_shape.shape as RectangleShape2D
				draw_rect(Rect2(collision_shape.position - rect.extents, rect.extents * 2), Color(1, 0, 0, 0.5))
