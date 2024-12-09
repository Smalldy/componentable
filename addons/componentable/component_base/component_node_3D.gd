extends Node2D
class_name ComponentNode2D
# 是否使用此组件
@export @onready var enable:bool = false

func get_host() -> Node :
	return  get_parent()
	
	