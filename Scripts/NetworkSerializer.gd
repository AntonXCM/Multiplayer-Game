class_name NetworkSerializer
static func serialize(node: Node) -> PackedByteArray:
	return var_to_bytes_with_objects(serializeDict(node))
	
static func serializeDict(node: Node) -> Dictionary:
	var dict = JSON.from_native(node, true)
	dict["__children"] = []
	dict["__name"] = node.name
	for child in node.get_children():
		if child is Node:
			dict["__children"].append(serializeDict(child))
	return dict

static func deserialize(bytes: PackedByteArray) -> Node:
	var node = deserializeDict(bytes_to_var_with_objects(bytes))
	if node is Node2D:
		node.position = Vector2.ZERO
	if Connector.playerId == 0:
		node.name = "Game"
	return node
static func deserializeDict(dict) -> Node:
	var node : Node = JSON.to_native(dict, true)
	node.name = dict.get("__name", "Game")
	for child_dict in dict.get("__children", []):
		var child = deserializeDict(child_dict)
		node.add_child(child)
		if child is Camera2D:
				child.enabled = true
	return node
