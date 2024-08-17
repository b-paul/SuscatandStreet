class_name FunctionBlock
extends Block

var arg1Connector: Connector
var arg2Connector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	arg1Connector = Connector.new(self, true, true, TypeType.new())
	arg2Connector = Connector.new(self, true, true, TypeType.new())
	resultConnector = Connector.new(self, false, true, UnknownType.new())
	parentNamespace = parentNamespace_
