class_name OrRightBlock
extends Block

var inputConnector: Connector
var typeConnector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	inputConnector = Connector.new(self, true, false, UnknownType.new())
	typeConnector = Connector.new(self, true, true, TypeType.new())
	resultConnector = Connector.new(self, false, false, UnknownType.new())
	parentNamespace = parentNamespace_
