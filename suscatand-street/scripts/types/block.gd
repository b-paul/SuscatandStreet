class_name Block
extends Node

var parentNamespace: Namespace

var inputConnectors: Array = Array()
var outputConnectors: Array = Array()
var typeConnectors: Array = Array()
var inferredConnectors: Array = Array()
var subNamespaces: Array = Array()

func wipe():
	for connector: Connector in inputConnectors:
		connector.value = null
	for connector: Connector in outputConnectors:
		connector.value = null
	for connector: Connector in typeConnectors:
		connector.value = null
	for connector: Connector in inferredConnectors:
		connector.type = UnknownType.new()
	for subNamespace: Namespace in subNamespaces:
		subNamespace.wipeNamespace()
