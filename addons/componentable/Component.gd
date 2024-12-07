class_name Component extends Object

static func has(node: Node, component_name: String):
	return ComponentWorker.has_component(node, component_name)

static func get_all(node: Node):
	return ComponentWorker.get_all_components(node)

static func find(node: Node, component_name: String):
	return ComponentWorker.find(node, component_name)

############### for component next ###############
static func create_gd_component(target_script_path: String, temp_extend: String, tmp_class_name: String, tmp_host_type: String) -> bool:
	var component_data: ComponentData = ComponentCore.replace_script_template(target_script_path, temp_extend, tmp_class_name, tmp_host_type)
	# 记录新的组件信息
	if ComponentDB.has_same_component_type(component_data.component_class_name):
		print("component type already exist")
		return false
	ComponentDB.set_component_info(component_data)
	return true

static func attach_gd_component(host: Node, target_script_path: String, component_class_name: String) -> Node:
	if host == null:
		return null
	if target_script_path == "":
		return null
	if component_class_name == "":
		return null
	return ComponentCore.attach_node_with_script(host, target_script_path, component_class_name)
	