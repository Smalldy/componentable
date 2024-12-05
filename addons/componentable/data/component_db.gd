@tool
extends Node

var component_data_dict:Dictionary = {}
var component_attched_array:Array[ComponentAttachData] = []
var plugin_instance:Component

func set_component_info(component_data:ComponentData) -> bool :
	component_data_dict[component_data.component_class_name] = component_data	
	return true
	
func remove_componet_info(component_class_name:String) -> bool:
	return component_data_dict.erase(component_class_name)
	
	
func find_componet_info(component_class_name:String) -> ComponentData:
	if component_data_dict.has(component_class_name):
		return component_data_dict[component_class_name]
	else:
		return null

func has_same_component_type(component_class_name:String) -> bool:
	if component_class_name in component_data_dict:
		return true
	else:
		return false

func add_attached_info(component_attach_data:ComponentAttachData) -> bool:
	component_attched_array.append(component_attach_data)
	return true

func get_attached_info() -> Array[ComponentAttachData]:
	return component_attched_array

func clear_attached_info() -> bool:
	component_attched_array = []
	return true
		
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
	