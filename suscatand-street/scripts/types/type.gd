class_name Type
extends Node

func equalTo(other: Type):
	if self is PrimType:
		return (other is PrimType) and (self.typeName == other.typeName)
	elif self is UnknownType:
		return other is UnknownType
	elif self is FalseType:
		return other is FalseType
	elif self is TrueType:
		return other is TrueType
	elif self is FunctionType:
		return (other is FunctionType) and (self.domain.equalTo(other.domain)) and (self.codomain.equalTo(other.codomain))
	elif self is TypeType:
		return other is TypeType
	else:
		assert(false)
