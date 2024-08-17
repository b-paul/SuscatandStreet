class_name ApplicatorBlock
extends Block

var functionConnector
var argConnector
var resultConnector

func _init():
	functionConnector = Connector.new(true, UnknownType.new())
	argConnector = Connector.new(true, UnknownType.new())
	resultConnector = Connector.new(false, UnknownType.new())
