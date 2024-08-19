extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var workspace: Control = $Workspace
	var inputScene = load("res://scenes/blocks/Input.tscn")
	var goalScene = load("res://scenes/blocks/Goal.tscn")
	var lambdaScene = load("res://scenes/blocks/Lambda.tscn")
	
	var typeA = PrimType.new("A")
	
	var inputA = inputScene.instantiate()
	workspace.add_child(inputA)
	inputA.connectors[0].type = TypeType.new()
	inputA.connectors[0].value = typeA
	inputA.connectors[0].display_type_name()
	inputA.global_position = Vector2(200,1600)
	
	var lambda1 = lambdaScene.instantiate()
	workspace.add_child(lambda1)
	lambda1.global_position = Vector2(500,400)
	lambda1.get_node("DragContainer/DragHandle").width = 1500
	lambda1.get_node("DragContainer/DragHandle").height = 1000
	lambda1.get_node("DragContainer/DragHandle").update()
	
	var lambda2 = lambdaScene.instantiate()
	lambda1.get_node("Workspace").add_child(lambda2)
	lambda2.position += Vector2(-250,100)
	
	var c: ConnectorNode = inputA.connectors[0]
	c.connectedNodes.append(lambda1.get_node("Connectors/InType"))
	c.connectedNodes.append(lambda1.get_node("Connectors/OutType"))
	c.connectedNodes.append(lambda2.get_node("Connectors/InType"))
	c.connectedNodes.append(lambda2.get_node("Connectors/OutType"))
	
	
	
	
	
	
	
	
