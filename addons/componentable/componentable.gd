@tool
extends EditorPlugin
var componentable2_ui: Control


func _enter_tree():
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
	ComponentCore.editor_interface.get_selection().selection_changed.connect(componentable2_ui._on_selection_changed)
	componentable2_ui.init_all()
	print("connected refresh_attach_list")
	ComponentCore.signal_bus.refresh_attach_list.connect(componentable2_ui._on_selection_changed)
	ComponentCore.signal_bus.refresh_all_component_list.connect(componentable2_ui.refresh_all)

	
func _exit_tree():
	remove_control_from_docks(componentable2_ui)
	remove_autoload_singleton("ComponentDB")
