class_name InputBlock
extends Block

var inputName: String
var connector: Connector

func _init(parentNamespace_: Namespace, inputName_: String, type_: Type, value_):
	inputName = inputName_
	connector = Connector.new(true, type_)
	parentNamespace = parentNamespace_
	connector.value = value_
