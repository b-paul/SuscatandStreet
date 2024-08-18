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
	elif self is AndType:
		return (other is AndType) and (self.type1.equalTo(other.type1)) and (self.type2.equalTo(other.type2))
	elif self is OrType:
		return (other is OrType) and (self.type1.equalTo(other.type1)) and (self.type2.equalTo(other.type2))
	else:
		assert(false)

func toString():
	if self is PrimType:
		return self.typeName
	elif self is UnknownType:
		return ""
	elif self is FalseType:
		return "⊥"
	elif self is TrueType:
		return "⊤"
	elif self is TypeType:
		return ""
	elif self is FunctionType:
		var domString = self.domain.toString()
		var codString = self.codomain.toString()
		if domString.length() != 1:
			domString = "(" + domString + ")"
		if codString.length() != 1:
			codString = "(" + codString + ")"
		return domString + "→" + codString
	elif self is AndType:
		var domString = self.type1.toString()
		var codString = self.type2.toString()
		if domString.length() != 1:
			domString = "(" + domString + ")"
		if codString.length() != 1:
			codString = "(" + codString + ")"
		return domString + "∧" + codString
	elif self is OrType:
		var domString = self.type1.toString()
		var codString = self.type2.toString()
		if domString.length() != 1:
			domString = "(" + domString + ")"
		if codString.length() != 1:
			codString = "(" + codString + ")"
		return domString + "∨" + codString
	
