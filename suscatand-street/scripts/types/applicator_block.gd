class_name ApplicatorBlock
extends Block

var functionConnector: Connector
var argConnector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	functionConnector = Connector.new(self, true, UnknownType.new())
	argConnector = Connector.new(self, true, UnknownType.new())
	resultConnector = Connector.new(self, false, UnknownType.new())
	parentNamespace = parentNamespace_
