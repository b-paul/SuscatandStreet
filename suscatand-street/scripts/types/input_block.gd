class_name InputBlock
extends Block

var connector: Connector

func _init(parentNamespace_: Namespace, type_: Type, value_):
	connector = Connector.new(self, false, type_ is TypeType, type_)
	parentNamespace = parentNamespace_
	assert(value_ != null)
	connector.value = value_

func wipe():
	pass
