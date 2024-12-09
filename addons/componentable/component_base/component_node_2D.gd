extends Node3D
class_name ComponentNode3D
# 是否使用此组件
@export @onready var enable:bool = false

func get_host() -> Node :
	return  get_parent()
	
	