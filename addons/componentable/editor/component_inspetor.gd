@tool

extends Control
class_name ComponentInspectorItem
######## var 
@onready var label_enable_status = $PanelContainer/HBoxContainer/LabelEnableStatus
@onready var component_data: ComponentData = null: set = set_component_data, get = get_component_data
@onready var component_attched_data: ComponentAttachData : set = set_component_attached_data, get = get_component_attached_data
@onready var attach_mod: bool = false: set = set_attach_mod

####### func
func set_component_data(data: ComponentData):
	component_data = data
	apply_data(component_data)
	
func get_component_data() -> ComponentData:
	return component_data

func set_component_attached_data(data: ComponentAttachData):
	print("set_component_attached_data", data)
	component_attched_data = data
	print("component_attched_data = ", component_attched_data)
	apply_attached_data(component_attched_data)

func get_component_attached_data() -> ComponentAttachData:
	return component_attched_data

func set_attach_mod(mod: bool):
	attach_mod = mod
	if attach_mod:
		$"%ButtonDetach".show()
		$"%ButtonAttach".hide()
		$"%CheckButtonEnableComp".show()
		$"%LabelEnableStatus".show()
		ComponentCore.signal_bus.current_inspector_edited_component_enable_changed.connect(func(enabled: bool):
			print("ComponentInspectorItem: _on_current_inspector_edited_component_enable_changed ", enabled)
			$"%CheckButtonEnableComp".button_pressed = enabled
		)
	else:
		$"%ButtonDetach".hide()
		$"%ButtonAttach".show()
		$"%CheckButtonEnableComp".hide()
		$"%LabelEnableStatus".hide()

func _on_check_button_enable_comp_toggled(toggled_on: bool) -> void:
	print("_on_check_button_enable_comp_toggled attach_mod = ", attach_mod)
	if !attach_mod:
		return
	print("_on_check_button_enable_comp_toggled toggled_on = ", toggled_on)
	print("_on_check_button_enable_comp_toggled component_attched_data = ", component_attched_data)
	var node_path = component_attched_data.component_path
	var comp = get_node(node_path)
	# 无法查找到组件的默认行为
	if !comp:
		$"%CheckButtonEnableComp".button_pressed = false
		printerr("comp is null! can not set the componet enable status to ", toggled_on)
		label_enable_status.text = "Disable"
		label_enable_status.add_theme_color_override("font_color", Color.RED)
		return

	print("_on_check_button_enable_comp_toggled comp.enable = ", comp.enable)
	# 如果不一致就更新数据
	if toggled_on and component_attched_data.enable == false:
		component_attched_data.enable = true
		
	elif !toggled_on and component_attched_data.enable == true:
		component_attched_data.enable = false
	else :
		# 如果新的值与旧的值相同，则不处理
		pass
	
	# 改变样式
	if toggled_on:
		comp.enable = true
		label_enable_status.text = "Enable"
		label_enable_status.add_theme_color_override("font_color", Color.GREEN)
	else:
		comp.enable = false
		label_enable_status.text = "Disable"
		label_enable_status.add_theme_color_override("font_color", Color.RED)


	
func apply_data(data: ComponentData):
	if data:
		$"%ComponentShowNameLabel".text = data.component_show_name
	pass

func apply_attached_data(data: ComponentAttachData):
	if data:
		$"%CheckButtonEnableComp".button_pressed = data.enable
	

func _on_remove_component_pressed() -> void:
	# print("_on_remove_component_pressed not implement")
	$"%ConfirmDeleteComponentDialog".show()
	pass # Replace with function body.


func _on_button_edit_script_pressed() -> void:
	print("_on_button_edit_script_pressed not implement")
	pass # Replace with function body.


func _on_button_attach_pressed() -> void:
	print("_on_button_attach_pressed ")
	Component.attach_gd_component(ComponentCore.get_selected_node(), component_data.script_resource_path, component_data.component_class_name)
	ComponentCore.signal_bus.refresh_attach_list.emit()
	print("ComponentCore.signal_bus.refresh_attach_list.emit() ")
	pass # Replace with function body.


func _on_button_detach_pressed() -> void:
	print("_on_button_detach_pressed not implement")
	Component.detach_gd_component(component_attched_data.component_path)
	ComponentCore.signal_bus.refresh_attach_list.emit()
	pass # Replace with function body.


func _on_confirm_delete_component_dialog_confirmed() -> void:
	# 此处本来是想删除分离所有组件 但是目前只能分离当前选中节点的组件 这会造成行为不一致
	# 因此目前的策略是组件由用户分离 因此产生的依赖丢失问题由用户解决
	# for component:ComponentAttachData in ComponentCore.get_host_attached_infos(ComponentCore.get_selected_node()) :
	# 	var component_node_path = component.component_path
	# 	if ComponentDB.has_same_component_type(component.component_class_name) :
	# 		Component.detach_gd_component(component_node_path)
	Component.remove_gd_component(component_data.component_class_name)
	pass # Replace with function body.

