class_name Connector
extends Node

var isInput: bool
var type: Type
var value = null # dynamically typed!! haha
var inConnections: Array = Array()
var outConnections: Array = Array()
var parentBlock: Block

func _init(parentBlock_: Block, isInput_: bool, type_: Type):
	parentBlock = parentBlock_
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

	# IF CONNECTING TO LAMBDA/ETC UPDATE NAMESPACE INPUTS!!!

	return 0

func remove_connection(target: Connector):
	pass
