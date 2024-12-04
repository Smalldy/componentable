@tool

extends Control
class_name ComponentInspectorItem
######## var 
@onready var label_enable_status = $PanelContainer/HBoxContainer/LabelEnableStatus
@onready var component_data: ComponentData = null: set = set_component_data, get = get_component_data
@onready var attach_mod: bool = false: set = set_attach_mod

####### func

func set_component_data(data: ComponentData):
	component_data = data
	apply_data(component_data)
	
func get_component_data() -> ComponentData:
	return component_data

func set_attach_mod(mod: bool):
	attach_mod = mod
	if attach_mod:
		$"%ButtonDetach".show()
		$"%ButtonAttach".hide()
		$"%CheckButtonEnableComp".show()
		$"%LabelEnableStatus".show()
	else:
		$"%ButtonDetach".hide()
		$"%ButtonAttach".show()
		$"%CheckButtonEnableComp".hide()
		$"%LabelEnableStatus".hide()
	

func _on_check_button_enable_comp_toggled(toggled_on: bool) -> void:
	# var comp = Component.find_component(component_data)
	# if !comp:
	# 	$"%CheckButtonEnableComp".button_pressed = false
	# 	printerr("comp is null! can not set the componet enable status to ", toggled_on)
	# 	label_enable_status.text = "Disable"
	# 	label_enable_status.add_theme_color_override("font_color", Color.RED)
		
	# 	return

	# if toggled_on:
	# 	# TODO: set component enable status to true
	# 	printerr("TODO: set component enable status to true",)
	# 	label_enable_status.text = "Enable"
	# 	label_enable_status.add_theme_color_override("font_color", Color.GREEN)
	# else:
	# 	# TODO: set component enable status to false
	# 	printerr("TODO: set component enable status to false")
	# 	label_enable_status.text = "Disable"
	# 	label_enable_status.add_theme_color_override("font_color", Color.RED)
	pass

	
func apply_data(data: ComponentData):
	$"%ComponentShowNameLabel".text = data.component_show_name
	pass
	

func _on_remove_component_pressed() -> void:
	print("_on_remove_component_pressed not implement")
	pass # Replace with function body.


func _on_button_edit_script_pressed() -> void:
	print("_on_button_edit_script_pressed not implement")
	pass # Replace with function body.


func _on_button_attach_pressed() -> void:
	pass # Replace with function body.


func _on_button_detach_pressed() -> void:
	pass # Replace with function body.
