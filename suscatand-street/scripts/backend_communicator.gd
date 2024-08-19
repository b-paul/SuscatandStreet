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

func get_parent_namespace(block: GenericBlock) -> Namespace:
	var currentNode: Node = block.get_parent()
	while true:
		if "i_am_a_block" in currentNode:
			if currentNode.block_type == "lambda":
				return currentNode.get_node("LambdaHandler").lambda_namespace
		if currentNode == get_tree().get_root():
			return bigNameSpace
		currentNode = currentNode.get_parent()
	return bigNameSpace
	
func construct_model_namespace(node: Node, parentNamespace: Namespace) -> Namespace:
	if "i_am_a_block" in node:
		var block: GenericBlock = node
		#add the block to the namespace
		if block in reverseBlockMappings:
			return
		match block.block_type:
			"input":
				var connector: ConnectorNode = block.connectors[0]
				var type = connector.type
				var inputBlock = InputBlock.new(parentNamespace, type, connector.value)
				blockMappings[inputBlock] = block
				reverseBlockMappings[block] = inputBlock
				connectorMappings[inputBlock.connector] = connector
				reverseConnectorMappings[connector] = inputBlock.connector
				parentNamespace.blocks.append(inputBlock)
			"goal":
				var connector: ConnectorNode = block.connectors[0]
				var type = connector.type
				var goalBlock = OutputBlock.new(parentNamespace, type)
				blockMappings[goalBlock] = block
				reverseBlockMappings[block] = goalBlock
				connectorMappings[goalBlock.connector] = connector
				reverseConnectorMappings[connector] = goalBlock.connector
				parentNamespace.blocks.append(goalBlock)
			"applicator":
				var inConnector: ConnectorNode = block.connectors[0]
				var outConnector: ConnectorNode = block.connectors[1]
				var funcConnector: ConnectorNode = block.connectors[2]
				var applicator = ApplicatorBlock.new(parentNamespace)
				blockMappings[applicator] = block
				reverseBlockMappings[block] = applicator
				connectorMappings[applicator.argConnector] = inConnector
				connectorMappings[applicator.resultConnector] = outConnector
				connectorMappings[applicator.functionConnector] = funcConnector
				reverseConnectorMappings[inConnector] = applicator.argConnector
				reverseConnectorMappings[outConnector] = applicator.resultConnector
				reverseConnectorMappings[funcConnector] = applicator.functionConnector
				parentNamespace.blocks.append(applicator)
			"lambda":
				var inTypeConnector: ConnectorNode = block.connectors[0]
				var outTypeConnector: ConnectorNode = block.connectors[1]
				var funcConnector: ConnectorNode = block.connectors[2]
				var lambdaHandler: LambdaHandler = block.get_node("LambdaHandler")
				var modelLambda: LambdaBlock = LambdaBlock.new(parentNamespace)
				
				blockMappings[modelLambda] = block
				reverseBlockMappings[block] = modelLambda
				
				connectorMappings[modelLambda.inputTypeConnector] = inTypeConnector
				connectorMappings[modelLambda.outputTypeConnector] = outTypeConnector
				connectorMappings[modelLambda.outputConnector] = funcConnector
				reverseConnectorMappings[inTypeConnector] = modelLambda.inputTypeConnector
				reverseConnectorMappings[outTypeConnector] = modelLambda.outputTypeConnector
				reverseConnectorMappings[funcConnector] = modelLambda.outputConnector
				
				var lambda_namespace: Namespace = modelLambda.lambdaNamespace
				
				blockMappings[modelLambda.innerInputBlock] = lambdaHandler.innerInputBlock
				reverseBlockMappings[lambdaHandler.innerInputBlock] = modelLambda.innerInputBlock
				connectorMappings[modelLambda.innerInputBlock.connector] = lambdaHandler.innerInputBlock.connectors[0]
				reverseConnectorMappings[lambdaHandler.innerInputBlock.connectors[0]] = modelLambda.innerInputBlock.connector
				
				blockMappings[modelLambda.innerOutputBlock] = lambdaHandler.innerOutputBlock
				reverseBlockMappings[lambdaHandler.innerOutputBlock] = modelLambda.innerOutputBlock
				connectorMappings[modelLambda.innerOutputBlock.connector] = lambdaHandler.innerOutputBlock.connectors[0]
				reverseConnectorMappings[lambdaHandler.innerOutputBlock.connectors[0]] = modelLambda.innerOutputBlock.connector
				
				lambdaHandler.lambda_namespace = lambda_namespace
				for child_node in block.get_node("Workspace").get_children():
					construct_model_namespace(child_node,lambda_namespace)
			"and":
				var inConnecter1: ConnectorNode = block.connectors[0]
				var inConnecter2: ConnectorNode = block.connectors[1]
				var andOut: ConnectorNode = block.connectors[2]
				var andBlock = AndBlock.new(parentNamespace)
				
				blockMappings[andBlock] = block
				reverseBlockMappings[block] = andBlock
				
				connectorMappings[andBlock.arg1Connector] = inConnecter1
				connectorMappings[andBlock.arg2Connector] = inConnecter2
				connectorMappings[andBlock.resultConnector] = andOut

				reverseConnectorMappings[inConnecter1] = andBlock.arg1Connector
				reverseConnectorMappings[inConnecter2] = andBlock.arg2Connector
				reverseConnectorMappings[andOut] = andBlock.resultConnector
				parentNamespace.blocks.append(andBlock)
			"or":
				var inConnecter1: ConnectorNode = block.connectors[0]
				var inConnecter2: ConnectorNode = block.connectors[1]
				var orOut: ConnectorNode = block.connectors[2]
				var orBlock = AndBlock.new(parentNamespace)
				
				blockMappings[orBlock] = block
				reverseBlockMappings[block] = orBlock
				
				connectorMappings[orBlock.arg1Connector] = inConnecter1
				connectorMappings[orBlock.arg2Connector] = inConnecter2
				connectorMappings[orBlock.resultConnector] = orBlock

				reverseConnectorMappings[inConnecter1] = orBlock.arg1Connector
				reverseConnectorMappings[inConnecter2] = orBlock.arg2Connector
				reverseConnectorMappings[orOut] = orBlock.resultConnector
				parentNamespace.blocks.append(orBlock)
			_:
				assert(false)
	else:
		for child_node in node.get_children():
			construct_model_namespace(child_node,parentNamespace)
	
	return parentNamespace
		
		

func check_game_state() -> bool:
	get_game_state()
	blockMappings = {}
	reverseBlockMappings = {}
	connectorMappings = {}
	reverseConnectorMappings = {}
	bigNameSpace = Namespace.new()
	construct_model_namespace($ConnectorCoordinator/LevelBuilder/Workspace, bigNameSpace)
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
