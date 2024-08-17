class_name OutputBlock
extends Block

var connector: Connector

func _init(parentNamespace_: Namespace, type_: Type):
	connector = Connector.new(self, true, false, type_)
	parentNamespace = parentNamespace_
