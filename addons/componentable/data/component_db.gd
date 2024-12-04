@tool
extends Node
# class_name ComponentDB

# 存储组件信息和当前插件运行时信息

var component_data_dict:Dictionary = {}
var plugin_instance:Component

func set_component_info(component_data:ComponentData) -> bool :
	component_data_dict[component_data.comp_id] = component_data	
	return true
	
func remove_componet_info(comp_id:String) -> bool:
	return component_data_dict.erase(comp_id)
	
	
func find_componet_info(comp_id:String) -> ComponentData:
	if component_data_dict.has(comp_id):
		return component_data_dict[comp_id]
	else:
		return null
func has_same_component_type(component_class_name:String) -> bool:
	for comp_id in component_data_dict:
		if component_data_dict[comp_id].component_class_name == component_class_name:
			return true
	return false
		
func dump_to_json() -> bool:
	var json_path = "res://addons/componentable/data/components.tres"
	var json:JSON = JSON.parse_string(JSON.stringify(component_data_dict))

	var error = ResourceSaver.save(json, json_path)
	if error != OK:
		push_error("dump to json failed")
		return false
	return true

func load_from_json() -> bool:
	var json_path = "res://addons/componentable/data/components.tres"
	var json:JSON = ResourceLoader.load(json_path)
	if json == null:
		push_error("load json failed")
		return false
	component_data_dict = json.data
	return true
	