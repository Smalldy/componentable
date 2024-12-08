extends ComponentNode
class_name Test 
@export @onready var host:Node = get_host()

const kComponentExtendTypeName = "ComponentNode"
const kComponentClassName = "Test"
const kComponentHostTypeName = "Node"

# you can implement your own get_host() method to return the host node 
# or specify the host node in the inspector, beacuse the host variable is exported

#func get_host() -> Node:
#    pass