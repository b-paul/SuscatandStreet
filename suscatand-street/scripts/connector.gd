class_name ConnectorNode extends CenterContainer

@export var isConnectorNode: bool = true
@export var connectedNodes: Array[ConnectorNode]
@export var wire_normal: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connectedNodes = []

func connect_node(node: ConnectorNode) -> void:
	connectedNodes.push_back(node)
	#communicate with backend

func disconnect_node(node: ConnectorNode) -> void:
	if not node in connectedNodes:
		return
	connectedNodes.erase(node)
	#communicate with backend
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
