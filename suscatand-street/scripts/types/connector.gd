class_name Connector
extends Node

var isInput: bool
var takesType: bool
var type: Type
var value = null # dynamically typed!! haha
var inConnections: Array = Array()
var outConnections: Array = Array()
var parentBlock: Block

func _init(parentBlock_: Block, isInput_: bool, takesType_: bool, type_: Type):
	parentBlock = parentBlock_
	isInput = isInput_
	takesType = takesType_
	type = type_

func make_connection(target: Connector):
	if outConnections.has(target):
		return 0
	if (self.isInput and !target.isInput):
		inConnections.append(target)
		target.outConnections.append(self)
	elif (!self.isInput and target.isInput):
		outConnections.append(target)
		target.inConnections.append(self)
	else:
		# do something random, it'll break
		outConnections.append(target)
		target.inConnections.append(self)

	# IF CONNECTING TO LAMBDA/ETC UPDATE NAMESPACE INPUTS!!!
	
	# typecheck the most-parent namespace

	return 0

func remove_connection(target: Connector):
	pass
