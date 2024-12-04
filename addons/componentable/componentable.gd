@tool
extends EditorPlugin


var componentable_ui: Control
var componentable2_ui: Control

func _enter_tree():
	# componentable_ui = preload("res://addons/componentable/editor/componentable_inspector.tscn").instantiate()
	# add_control_to_dock(DockSlot.DOCK_SLOT_RIGHT_UL, componentable_ui)
	add_autoload_singleton("ComponentDB", "res://addons/componentable/data/component_db.gd")

	componentable2_ui = preload("res://addons/componentable/editor/componenttable_inspector_v2.tscn").instantiate()
	add_control_to_dock(DockSlot.DOCK_SLOT_RIGHT_UL, componentable2_ui)
	componentable2_ui.editor_plugin = self
	

func _exit_tree():
	# remove_control_from_docks(componentable_ui)
	remove_control_from_docks(componentable2_ui)
	remove_autoload_singleton("ComponentDB")