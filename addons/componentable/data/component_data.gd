#######################################
# 保存组件静态信息
#######################################

extends Node
class_name ComponentData
enum ComponentType {
	kSceneComponent, #场景类组件 本地会保存一个tscn+脚本，用于更加复杂的情况
	kScriptComponent #脚本类组件 通常是一个节点+脚本的简单组合， 只有脚本会保存在本地
}

######################### 配置信息 ###################
## id 唯一标识符
var comp_id:String = ""
## 展示再插件上的名称
var component_show_name:String = ""
## 组件是否处于激活状态
var component_enable:bool = true
## 组件类型
var component_type:ComponentType = ComponentType.kScriptComponent
## 宿主类型名
var host_type_name:String 
## extend 类型名
var extend_class_name:String
## 组件本身的类型名
var component_class_name:String
## 资源路径 kScriptComponent kSceneComponent 有效
var script_resource_path:String
## kSceneComponent 有效
var tscn_resource_path:String
