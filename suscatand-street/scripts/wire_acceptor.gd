class_name WireAcceptor extends Control

@export var is_wire_acceptor: bool = true
@export var connectedNodes: Array[WireEnd]
@export var connectedDragStartPositions: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connectedNodes = []

func accept(node: WireEnd):
	connectedNodes.push_back(node)
	node.z_index = z_index + 1
	node.isSticky = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#@export func accept_connection()
