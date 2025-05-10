extends Area2D

@export var objectToSpawn : String
@export var isGrid : bool
func _ready() -> void:
	set_pickable(true)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton or not (event as InputEventMouseButton).is_released():
		return
	var player = Connector.Players[Connector.playerId]["object"] as GridObject
	if isGrid:
		player.grid.rpc_place_object(load(objectToSpawn).instantiate(), player.get_grid_position())
	else:
		spawn_non_grid.rpc(objectToSpawn,player.grid.get_child(0).get_path(), player.global_position)

@rpc("any_peer","call_local")
func spawn_non_grid(path:String, parent:NodePath,pos: Vector2):
	var object = load(path).instantiate()
	get_node(parent).add_child(object)
	object.global_position = pos
