class_name Connector

var isInput: bool
var type: Type
var value # dynamically typed!! haha

func _init(isInput_: bool, type_: Type):
	isInput = isInput_
	type = type_
	value = null
