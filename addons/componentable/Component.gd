class_name Component extends Object

static func create_gd_component(target_script_path: String, temp_extend: String, tmp_class_name: String, tmp_host_type: String) -> bool:
	var component_data: ComponentData = ComponentCore.replace_script_template(target_script_path, temp_extend, tmp_class_name, tmp_host_type)
	# 记录新的组件信息
	if ComponentDB.has_same_component_type(component_data.component_class_name):
		print("component type already exist")
		return false
	ComponentDB.set_component_info(component_data)
	return true

static func remove_gd_component(component_class_name: String) -> bool:
	if ComponentDB.has_same_component_type(component_class_name):
		var component_data:ComponentData = ComponentDB.find_componet_info(component_class_name)
		if FileAccess.file_exists(component_data.script_resource_path):
			# OS.move_to_trash(component_data.script_resource_path)
			print("remove file = ", component_data.script_resource_path)
			DirAccess.remove_absolute(component_data.script_resource_path)
		ComponentDB.remove_component_info(component_class_name)
		ComponentDB.dump_to_res()
		return true
	return false

static func attach_gd_component(host: Node, target_script_path: String, component_class_name: String) -> Node:
	if host == null:
		return null
	if target_script_path == "":
		return null
	if component_class_name == "":
		return null
	return ComponentCore.attach_node_with_script(host, target_script_path, component_class_name)
	
static func detach_gd_component(component_path: String):
	ComponentCore.remove_component_node(component_path)
