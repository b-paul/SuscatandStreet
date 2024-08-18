class_name NotElimBlock
extends Block

var falseConnector: Connector
var typeConnector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	falseConnector = Connector.new(self, true, false, FalseType.new())
	typeConnector = Connector.new(self, true, true, TypeType.new())
	resultConnector = Connector.new(self, false, false, UnknownType.new())
	parentNamespace = parentNamespace_
