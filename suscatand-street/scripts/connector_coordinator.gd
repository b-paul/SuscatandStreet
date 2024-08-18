class_name ConnectorCoordinator extends Node2D

@export var dragging_wire: bool = false
@export var just_dropped: bool = false
@export var connectors: Array[ConnectorNode]

# Called when the node enters the scene tree for the first time.

func find_connectors(root_node: Node) -> Array[ConnectorNode]:
	var nodes_of_type: Array[ConnectorNode] = []
	# Recursive function to traverse children
	
	var traverse = func traverse(node: Node, this_function):
		if "is_connector_node" in node:
			nodes_of_type.append(node)
		else:
			for child in node.get_children():
				this_function.call(child, this_function)

	traverse.call(root_node, traverse)
	
	return nodes_of_type

func _ready() -> void:
	connectors = find_connectors(get_node("."))
	for c in connectors:
		c.coordinator = self
		c.controller = self.get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
