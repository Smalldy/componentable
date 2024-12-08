@tool
extends Panel
var inspector_item_packed_scene = preload("res://addons/componentable/editor/component_inspetor.tscn")
@onready var editor_plugin:EditorPlugin
var selected_node:Node

func _ready() -> void:
	print("componentable_inspector_v_2 ready, self = ", self)
	ComponentDB.load_from_json()
	pass

func _on_button_add_comp_pressed() -> void:
	var editor_interface = editor_plugin.get_editor_interface()
	var selected_size = editor_interface.get_selection().get_selected_nodes().size()
	if selected_size == 0:
		print('No node selected, can not create component')
		return
	selected_node = editor_interface.get_selection().get_selected_nodes()[0]
	$"%CreateComponentDialog".set_editor_plugin(editor_plugin)
	$"%CreateComponentDialog".set_host(editor_interface.get_selection().get_selected_nodes()[0])
	$"%CreateComponentDialog".show()
	pass

func add_component_to_all(component_class_name:String):
	var inspector_item:ComponentInspectorItem = inspector_item_packed_scene.instantiate()
	var component_data:ComponentData = ComponentDB.find_componet_info(component_class_name)
	$"%VBoxContainerAll".add_child(inspector_item)
	inspector_item.attach_mod = false
	inspector_item.set_component_data(component_data)

func add_component_to_attached(component_class_name:String, attached_info:ComponentAttachData):
	var inspector_item:ComponentInspectorItem = inspector_item_packed_scene.instantiate()
	var component_data:ComponentData = ComponentDB.find_componet_info(component_class_name)
	$"%VBoxContainerAttach".add_child(inspector_item)
	inspector_item.attach_mod = true
	inspector_item.set_component_data(component_data)
	inspector_item.set_component_attached_data(attached_info)
	pass

func get_attached_info(component:Node) -> ComponentAttachData: 
	var info:ComponentAttachData = ComponentAttachData.new()
	info.component_path = component.get_path()
	info.component_class_name = component.get_script().get_global_name()
	info.enable = component.enable
	return info
	
func refresh_attached():
	for child in $"%VBoxContainerAttach".get_children():
		child.queue_free()

	var all_attched = ComponentDB.get_attached_info()
	for attached_info in all_attched:
		add_component_to_attached(attached_info.component_class_name, attached_info)
	pass
	
func init_all():
	for key in ComponentDB.component_data_dict:
		add_component_to_all(key)
	pass

func _on_create_component_dialog_new_component_created(component_class_name:String) -> void:
	print('_on_create_component_dialog_new_component_created')
	add_component_to_all(component_class_name)
	ComponentDB.dump_to_json()
	pass # Replace with function body.

func _on_create_component_dialog_component_attached() -> void:
	print('_on_create_component_dialog_component_attached')
	ComponentDB.clear_attached_info()
	var children = selected_node.get_children()
	for child in children:
		if child.is_in_group("components"):
			var component_class_name = child.get_script().get_global_name()
			var attached_info:ComponentAttachData = ComponentAttachData.new()
			attached_info.component_path = child.get_path()
			attached_info.component_class_name = component_class_name
			ComponentDB.add_attached_info(attached_info)

	refresh_attached()

	pass # Replace with function body.


func _on_selection_changed() -> void:
	print('selection changed!')
	var current_node = ComponentCore.get_selected_node()
	var attached_component_nodes:Array = ComponentCore.get_child_component_nodes(current_node)
	ComponentDB.clear_attached_info()
	for attached_node in attached_component_nodes:
		var attached_info = get_attached_info(attached_node)
		ComponentDB.add_attached_info(attached_info)
	refresh_attached()
	pass