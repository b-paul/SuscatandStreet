class_name Connector
extends Node

var isInput: bool
var type: Type
var value = null # dynamically typed!! haha
var inConnections: Array = Array()
var outConnections: Array = Array()

func _init(isInput_: bool, type_: Type):
	isInput = isInput_
	type = type_

# Returns -1 if connecting output to output
func make_connection(target: Connector):
	if !isInput and !target.isInput:
		return -1
	if outConnections.has(target):
		return 0
	outConnections.append(target)
	target.inConnections.append(self)
	return 0
