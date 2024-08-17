class_name ApplicatorBlock
extends Block

var functionConnector: Connector
var argConnector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	functionConnector = Connector.new(true, UnknownType.new())
	argConnector = Connector.new(true, UnknownType.new())
	resultConnector = Connector.new(false, UnknownType.new())
	parentNamespace = parentNamespace_
