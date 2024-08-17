class_name Connector
extends Node

var isInput: bool
var type: Type
var value = null # dynamically typed!! haha
var connections: Array = Array()

func _init(isInput_: bool, type_: Type):
	isInput = isInput_
	type = type_
