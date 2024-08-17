class_name InputBlock
extends Block

var connector: Connector

func _init(parentNamespace_: Namespace, type_: Type, value_):
	connector = Connector.new(self, false, false, type_)
	parentNamespace = parentNamespace_
	connector.value = value_

