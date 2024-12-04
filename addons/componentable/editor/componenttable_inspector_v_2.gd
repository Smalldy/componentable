@tool
extends Panel
var inspector_item_packed_scene = preload("res://addons/componentable/editor/component_inspetor.tscn")
@onready var editor_plugin:EditorPlugin

func _on_button_add_comp_pressed() -> void:
	var editor_interface = editor_plugin.get_editor_interface()
	var selected_size = editor_interface.get_selection().get_selected_nodes().size()
	if selected_size == 0:
		print('No node selected, can not create component')
		return
	$"%CreateComponentDialog".set_editor_plugin(editor_plugin)
	$"%CreateComponentDialog".set_host(editor_interface.get_selection().get_selected_nodes()[0])
	$"%CreateComponentDialog".show()
	pass

func add_component_to_all(comp_id:String):
	var inspector_item:ComponentInspectorItem = inspector_item_packed_scene.instantiate()
	inspector_item.attach_mod = false
	var component_data = ComponentDB.find_componet_info(comp_id)
	inspector_item.set_component_data(component_data)
	$"%VBoxContainerAll".add_child(inspector_item)