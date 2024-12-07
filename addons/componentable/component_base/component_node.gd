extends Node
class_name ComponentNode
# 是否使用此组件
@export @onready var enable:bool = false

func get_host() -> Node :
	return  get_parent()
	