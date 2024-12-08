extends Node
class_name ComponentCore
const tmp_script_file_path: String = "res://addons/componentable/component_base/component_node_extend_template.tmp"
const COMPONENT_GROUP_NAME: String = "component_group"

static var editor_plugin: EditorPlugin = null
static var editor_interface: EditorInterface = null
static var editor_inspector: EditorInspector = null
static var signal_bus: ComponentSignalBus = null


static func set_editor_plugin(new_editor_plugin: EditorPlugin):
	editor_plugin = new_editor_plugin
	if editor_plugin:
		editor_interface = editor_plugin.get_editor_interface()
		editor_inspector = editor_interface.get_inspector()
	else:
		editor_interface = null

static func get_editor_plugin() -> EditorPlugin:
	return editor_plugin

static func get_selected_node() -> Node:
	if editor_interface.get_selection().get_selected_nodes().size():
		return editor_interface.get_selection().get_selected_nodes()[0]
	else:
		return null


static func replace_script_template(target_script_path: String, temp_extend: String, tmp_class_name: String, tmp_host_type: String) -> ComponentData:
	# 读取tmp_script_file_path文件
	var tmp_script_file = FileAccess.open(tmp_script_file_path, FileAccess.READ)
	var tmp_script_content = tmp_script_file.get_as_text()
	# 替换模板中的内容 TMP_EXTEND_TYPE TMP_CLASS_NAME TMP_HOST_TYPE
	tmp_script_content = tmp_script_content.replacen("TMP_EXTEND_TYPE", temp_extend)
	tmp_script_content = tmp_script_content.replacen("TMP_CLASS_NAME", tmp_class_name)
	tmp_script_content = tmp_script_content.replacen("TMP_HOST_TYPE", tmp_host_type)
	print("gen script file: ", target_script_path, "\ncontent = \n", tmp_script_content)
	# 写入到target_script_path文件中
	var target_script_file = FileAccess.open(target_script_path, FileAccess.WRITE)
	target_script_file.store_string(tmp_script_content)
	target_script_file.close()
	tmp_script_file.close()

	# 创建componentdata
	var component_data = ComponentData.new()
	component_data.component_show_name = tmp_class_name.capitalize()
	component_data.component_enable = true
	component_data.component_type = ComponentData.ComponentType.kScriptComponent
	component_data.host_type_name = tmp_host_type
	component_data.extend_class_name = temp_extend
	component_data.component_class_name = tmp_class_name
	component_data.script_resource_path = target_script_path
	
	return component_data
	

# 创建节点并挂载脚本 
static func attach_node_with_script(host: Node, target_script_path: String, component_class_name: String) -> Node:
	var component_data: ComponentData = ComponentDB.find_componet_info(component_class_name)
	var editor_plugin = EditorPlugin.new()
	var script: GDScript = load(target_script_path)
	var node = script.new()
	host.add_child(node)
	node.name = component_data.component_class_name
	node.add_to_group("components", true)
	node.owner = editor_plugin.get_editor_interface().get_edited_scene_root()
	return node


static func get_class_name_from_file_basename(base_name: String) -> String:
	var compoent_class_name = base_name
	compoent_class_name = compoent_class_name.capitalize()
	compoent_class_name = compoent_class_name.replace(" ", "")
	return compoent_class_name

static func is_current_node_a_component() -> bool:
	var selected_node = get_selected_node()
	if selected_node and ComponentDB.has_same_component_type(selected_node.get_script().get_global_name()):
		return true
	return false

static func get_child_component_nodes(host: Node) -> Array:
	if not host:
		print('get_child_component_nodes host is null')
		return []

	var components:Array = []
	for child in host.get_children():
		if child.is_in_group('components') and  ComponentDB.has_same_component_type(child.get_script().get_global_name()):
			components.append(child)
		
	return components

static func get_host_attached_infos(host: Node) -> Array[ComponentAttachData]:
	var attach_infos:Array[ComponentAttachData] = []
	for component in get_child_component_nodes(host):
		var attach_info = ComponentAttachData.new()
		attach_info.component_path = component.get_path()
		attach_info.component_class_name = component.get_script().get_global_name()
		attach_info.enable = host.get_node(attach_info.component_path).enable
		attach_infos.append(attach_info)
	return attach_infos