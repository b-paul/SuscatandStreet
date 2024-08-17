class_name AndMkBlock
extends Block

var input1Connector: Connector
var input2Connector: Connector
var resultConnector: Connector

func _init(parentNamespace_: Namespace):
	input1Connector = Connector.new(self, true, false, UnknownType.new())
	input2Connector = Connector.new(self, true, false, UnknownType.new())
	resultConnector = Connector.new(self, false, false, UnknownType.new())
	parentNamespace = parentNamespace_
