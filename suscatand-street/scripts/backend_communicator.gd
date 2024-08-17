class_name BackendCommunicator extends Node2D

@export var blocks: Array[GenericBlock]
@export var connectors: Dictionary

func enumerate_blocks(root_node: Node) -> Array[GenericBlock]:
	var nodes_of_type: Array[GenericBlock] = []

	var traverse = func traverse(node: Node, this_function):
		if "i_am_a_block" in node:
			nodes_of_type.append(node)
		else:
			for child in node.get_children():
				this_function.call(child, this_function)
	traverse.call(root_node, traverse)
	return nodes_of_type

# Called when the node enters the scene tree for the first time.
func get_game_state() -> void:
	blocks = enumerate_blocks(self)
	var i = 0
	for block in blocks:
		var block_connectors: Array[ConnectorNode] = block.connectors
		for connector in block_connectors:
			connectors[i] = connector

func get_connector_index(node: ConnectorNode) -> int:
	var block: GenericBlock = node.get_parent().get_parent()
	return block.connectors.find(node)

func check_game_state() -> bool:
	get_game_state()
	var bigNameSpace: Namespace = Namespace.new()
	for block in blocks:
		match block.block_type:
			"input":
				var type = PrimType.new(block.connectors[0].type_name)
				var inputBlock = InputBlock.new(bigNameSpace, type, true)
			"goal":
				pass
			"applicator":
				pass
			_:
				assert(false)
	return false
	 
	
func _ready():
	print($ConnectorCoordinator/Workspace.get_children())
	#get_game_state()
	#print("blocks:")
	#for block in blocks:
		#print(block.block_type)
	#print(connectors)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
