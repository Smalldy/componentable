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
	var res_path = "res://addons/componentable/user_component_data/components.tres"
	var res = ComponnetDataRes.new()
	res.component_data_dict = component_data_dict
	var error = ResourceSaver.save(res, res_path)
	if error != OK:
		push_error("dump to res failed ", self)
		return false
	return true

func load_from_json() -> bool:
	var res_path = "res://addons/componentable/user_component_data/components.tres"
	if not ResourceLoader.exists(res_path):
		return true
		
	var comp_dict_res:ComponnetDataRes = ResourceLoader.load(res_path)
	if comp_dict_res == null:
		push_error("load res failed ", self)
		return false
	component_data_dict = comp_dict_res.component_data_dict
	print("load component res sunncess , data = ", component_data_dict)
	return true
	