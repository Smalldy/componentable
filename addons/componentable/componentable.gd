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

	ComponentCore.set_editor_plugin(self)
	ComponentCore.signal_bus = ComponentSignalBus.new()
	
	var ret = ComponentCore.editor_inspector.property_edited.connect(func(property: String):
		print("Componentable: property_edited: ", property)
		var selected_node = ComponentCore.get_selected_node();
		if ComponentCore.is_current_node_a_component() and property == "enable":
			print("Componentable: property_edited: ", property, " selected_node: ", selected_node)
			ComponentCore.signal_bus.current_inspector_edited_component_enable_changed.emit(
				ComponentCore.editor_inspector.get_edited_object().get(property)
			)
	)



	
func _exit_tree():
	# remove_control_from_docks(componentable_ui)
	remove_control_from_docks(componentable2_ui)
	remove_autoload_singleton("ComponentDB")
