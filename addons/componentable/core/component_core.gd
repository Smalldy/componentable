extends Node
class_name ComponentCore
const tmp_script_file_path:String = "res://addons/componentable/component_base/component_node_extend_template.tmp"

const COMPONENT_GROUP_NAME:String = "component_group"



static func replace_script_template(target_script_path: String, temp_extend:String, tmp_class_name:String, tmp_host_type:String) -> String:
	# 读取tmp_script_file_path文件
	var tmp_script_file = FileAccess.open(tmp_script_file_path, FileAccess.READ)
	var tmp_script_content = tmp_script_file.get_as_text()
	# 替换模板中的内容 TMP_EXTEND_TYPE TMP_CLASS_NAME TMP_HOST_TYPE
	tmp_script_content = tmp_script_content.replacen("TMP_EXTEND_TYPE", temp_extend)
	tmp_script_content = tmp_script_content.replacen("TMP_CLASS_NAME", tmp_class_name)
	tmp_script_content = tmp_script_content.replacen("TMP_HOST_TYPE", tmp_host_type)
	print("gen script file: ", target_script_path , "\ncontent = \n" , tmp_script_content)
	# 写入到target_script_path文件中
	var target_script_file = FileAccess.open(target_script_path, FileAccess.WRITE)
	target_script_file.store_string(tmp_script_content)
	target_script_file.close()
	tmp_script_file.close()

	# 创建componentdata
	var component_data = ComponentData.new()
	component_data.comp_id = Script.generate_scene_unique_id()
	component_data.component_show_name = tmp_class_name.capitalize()
	component_data.component_enable = true
	component_data.component_type = ComponentData.ComponentType.kScriptComponent
	component_data.host_type_name = tmp_host_type
	component_data.extend_class_name = temp_extend
	component_data.component_class_name = tmp_class_name
	component_data.script_resource_path = target_script_path
	component_data.host = null
	ComponentDB.set_component_info(component_data)

	return component_data.comp_id
	

# 创建节点并挂载脚本 
static func attach_node_with_script(host:Node, target_script_path:String, comp_id:String) -> String:
	var component_data:ComponentData = ComponentDB.find_componet_info(comp_id)
	var editor_plugin = EditorPlugin.new()
	var script:GDScript = load(target_script_path)
	var node = script.new()
	node.name = component_data.component_class_name
	host.add_child(node)
	node.owner = editor_plugin.get_editor_interface().get_edited_scene_root()
	component_data.host = host
	ComponentDB.set_component_info(component_data)

	return comp_id