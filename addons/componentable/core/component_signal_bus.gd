extends Node
class_name ComponentSignalBus

# 此信号表明当前inspector处于编辑状态的组件的enable状态发生了变化
signal current_inspector_edited_component_enable_changed(enabled: bool)
signal refresh_attach_list()
signal refresh_all_component_list()