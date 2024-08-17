class_name Namespace
extends Node

var blocks: Array = Array()
var parentBlock = null

func typeCheck():
	var stack: Array = Array()
	var checked: Dictionary = Dictionary()
	for block: Block in blocks:
		if block is InputBlock:
			stack.append(block.connector)
	while !stack.is_empty():
		var cur = stack.pop_back()
	# Must propogate function type
	# If reach applicator with input first, function must be of that form
	# If reach applicator with function first, input must be of that form

	# Check we dont go out of namespace
	pass # TODO
