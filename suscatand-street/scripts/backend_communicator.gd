class_name BackendCommunicator extends Node2D

@export var blocks: Array[GenericBlock]
@export var connectors: Dictionary
var bigNameSpace: Namespace = Namespace.new()
var blockMappings: Dictionary = {}
var reverseBlockMappings: Dictionary = {}
var connectorMappings: Dictionary = {}
var reverseConnectorMappings: Dictionary = {}

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

func render_game_state() -> void:
	var isWon: bool = check_game_state()
	for connector: ConnectorNode in reverseConnectorMappings.keys():
		var modelConnector: Connector = reverseConnectorMappings[connector]
		#print("Updating the following connector:")
		#print(connector)
		#print(modelConnector)
		connector.type = modelConnector.type
		connector.display_type_name()
		if modelConnector.value == null:
			#sad
			connector.set_color(Color.RED)
		else:
			#happy
			connector.set_color(Color.BLUE)
	for block: GenericBlock in reverseBlockMappings.keys():
		if block.block_type != "goal":
			continue
		var connector: ConnectorNode = block.connectors[0]
		var happinessHandler: GoalHappinessHandler = block.get_child(2)
		if reverseConnectorMappings[connector].value != null:
			happinessHandler.make_happy()
		else:
			happinessHandler.make_sad()
			
	if isWon:
		#win condition
		pass

func check_game_state() -> bool:
	get_game_state()
	bigNameSpace = Namespace.new()
	blockMappings = {}
	reverseBlockMappings = {}
	connectorMappings = {}
	reverseConnectorMappings = {}
	for block in blocks:
		match block.block_type:
			"input":
				var connector: ConnectorNode = block.connectors[0]
				var type = connector.type
				var inputBlock = InputBlock.new(bigNameSpace, type, true)
				blockMappings[inputBlock] = block
				reverseBlockMappings[block] = inputBlock
				connectorMappings[inputBlock.connector] = connector
				reverseConnectorMappings[connector] = inputBlock.connector
				bigNameSpace.blocks.append(inputBlock)
			"goal":
				var connector: ConnectorNode = block.connectors[0]
				var type = connector.type
				var goalBlock = OutputBlock.new(bigNameSpace, type)
				blockMappings[goalBlock] = block
				reverseBlockMappings[block] = goalBlock
				connectorMappings[goalBlock.connector] = connector
				reverseConnectorMappings[connector] = goalBlock.connector
				bigNameSpace.blocks.append(goalBlock)
			"applicator":
				var inConnector: ConnectorNode = block.connectors[0]
				var outConnector: ConnectorNode = block.connectors[1]
				var funcConnector: ConnectorNode = block.connectors[2]
				var applicator = ApplicatorBlock.new(bigNameSpace)
				blockMappings[applicator] = block
				reverseBlockMappings[block] = applicator
				connectorMappings[applicator.argConnector] = inConnector
				connectorMappings[applicator.resultConnector] = outConnector
				connectorMappings[applicator.functionConnector] = funcConnector
				reverseConnectorMappings[inConnector] = applicator.argConnector
				reverseConnectorMappings[outConnector] = applicator.resultConnector
				reverseConnectorMappings[funcConnector] = applicator.functionConnector
				bigNameSpace.blocks.append(applicator)
			_:
				assert(false)
	for connector: ConnectorNode in reverseConnectorMappings.keys():
		for otherConnector in connector.connectedNodes:
			var modelConnector: Connector = reverseConnectorMappings[connector]
			var otherModelConnector: Connector = reverseConnectorMappings[otherConnector]
			modelConnector.make_connection(otherModelConnector)
	return bigNameSpace.typeCheck()
	 
	
func _ready():
	render_game_state()
	#get_game_state()
	#print("blocks:")
	#for block in blocks:
		#print(block.block_type)
	#print(connectors)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
