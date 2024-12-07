@tool

extends FileDialog
class_name CreateComponentDialog

# 组件继承候选项
var component_extands_types: Array = ["ComponentNode", "ComponentNode2D", "ComponentNode3D", "ComponentNodeUI"]
var component_extands_type: String = ""
# 宿主类型候选项
var component_host_types: Array = []

var editor_plugin: EditorPlugin: set = set_editor_plugin
var editor_interface: EditorInterface

var host_class_name_str_script_custom_type_name: String
var host_class_name_str_script_build_in_type_name: String
var host_class_name_str_script_node_type_name: String

signal new_component_created(component_class_name: String)
signal component_attached()

func _ready() -> void:
	add_unique_option("ComponentGroupNode", [], 0)
	add_unique_option("ComponentExtendsType", component_extands_types, 0)
	add_unique_option("ComponentHostType", component_host_types, 0)

	add_unique_filter("*.gd", "Script Component")
	add_unique_filter("*.tscn", "Scene Compoennt")
	# how to get my current plugin instance ?

func set_editor_plugin(value: EditorPlugin):
	editor_plugin = value
	editor_interface = editor_plugin.get_editor_interface()

func set_host(host: Node):
	var type_set: Dictionary = {}

	var host_script = host.get_script()
	var class_name_str: String = ""
	var top_level_type: String = ""
	# 宿主类型可以是宿主类型本身和其所有父类
	# 这里有一个实现细节问题
	# 最重要的一点是 ClassDB.get_parent_class 不能处理域自定义类名(class_name)
	# host_script.get_global_name() 可以得到class_name  --> 要单独处理 添加到type_set中
	# host_script.get_instance_base_type() 可以得到此脚本继承的内置类型 
	# 经过下面逻辑的处理之后，我们能得到 --> 自定义类 和 所有继承的类
	# 这些就是生成的组件脚本中的宿主类型的可选项
	if host_script:
		class_name_str = host_script.get_global_name()
		if class_name_str != "":
			# top_level_type = class_name_str
			type_set[class_name_str] = true
			top_level_type = host_script.get_instance_base_type()
	else:
		top_level_type = host.get_class()

	# 获取 top_level_type 所有父类
	while top_level_type != "":
		type_set[top_level_type] = true
		top_level_type = ClassDB.get_parent_class(top_level_type)

	print("host type set = ", type_set.keys())
	component_host_types = type_set.keys()
	add_unique_option("ComponentHostType", component_host_types, 0)

	# 组件脚本继承什么取决于宿主，
	# 如果宿主类型包含Node3D，则继承ComponentNode3D
	# 如果宿主类型包含Node2D，则继承ComponentNode2D
	# 如果宿主类型包含 Control ,则继承 ComponentNodeUI
	# 如果宿主类型包含Node，则继承ComponentNode
	if "Node3D" in component_host_types:
		component_extands_type = "ComponentNode3D"
	elif "Node2D" in component_host_types:
		component_extands_type = "ComponentNode2D"
	elif "Control" in component_host_types:
		component_extands_type = "ComponentNodeUI"
	else:
		component_extands_type = "ComponentNode"

	# 还没有处理什么？ 比如：viewport 等其他继承自Node的类
	# 后续可以根据实际的需求进一步扩展

	add_unique_option("ComponentExtendsType", [component_extands_type], 0)

func _on_canceled() -> void:
	pass # Replace with function body.

func _on_confirmed() -> void:
	if current_file == "":
		print('no file created')
		return
	# 创建组件加载到当前选择的节点上
	var selected_options = get_selected_options()
	print(selected_options)
	var host_type = component_host_types[selected_options["ComponentHostType"]]
	var extend_type = component_extands_type
	# 类名用文件名做转换 格式最终转换为 SomeThing 
	var compoent_class_name = ComponentCore.get_class_name_from_file_basename(current_file.get_file().get_basename())
	
	
	print("component class name = ", compoent_class_name)
	print("component host type name = ", host_type)
	print("component extend type name = ", extend_type)

	# 用户指导：组件脚本中的宿主类型应该选择什么？
	# 使用更宽泛的类型可以增加适用范围，使用更精确的类型可以更加定制化
	# 如果创建分组节点 那么同类型的组件将会挂在在一个分类节点下 这个分类节点的类型只能是Node Node2D Node3D Control中的一种
	
	var selected_nodes = editor_interface.get_selection().get_selected_nodes()
	var selected_node = selected_nodes[0]
	# 获取文件的后缀
	var current_file_type = current_file.get_extension()
	print("will create file ",current_path)
	if current_file_type == "gd":
		if Component.create_gd_component(current_path, extend_type, compoent_class_name, host_type) :
			new_component_created.emit(compoent_class_name)
		else:
			print("create gd component failed")
			return

		var node_attached:Node = Component.attach_gd_component(selected_node, current_path, compoent_class_name) 
		if node_attached != null:
			component_attached.emit()
		else:
			print("attach gd component failed")
			return
	
		

	elif current_file_type == "tscn":
		pass
	else:
		return


	pass # Replace with function body.


func add_unique_option(name: String, values: Array, default_value: int) -> void:
	for i in range(option_count):
		# 如果已经存在 那么更新
		if get_option_name(i) == name:
			set_option_values(i, values)
			return
	# 不存在就直接增加
	add_option(name, values, default_value)

func add_unique_filter(pattern: String, description: String) -> void:
	for filter in filters:
		if filter == pattern + " ; " + description:
			return
	add_filter(pattern, description)

