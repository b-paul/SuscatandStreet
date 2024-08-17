class_name WireAcceptor extends Control

@export var is_wire_acceptor: bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func accept(node: WireEnd):
	var goal_block: GoalBlock = get_parent().get_parent().get_parent()
	goal_block.connectedNodes.push_back(node)
	node.z_index = z_index + 1
	node.isSticky = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#@export func accept_connection()
