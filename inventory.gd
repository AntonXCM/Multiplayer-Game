extends Area2D

@export var objectToSpawn : String
func _ready() -> void:
	set_pickable(true)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if not event is InputEventMouseButton or not (event as InputEventMouseButton).is_released():
		return
	var player = Connector.Players[Connector.playerId]["object"] as GridObject
	print(player.name)
	player.grid.rpc_place_object(load(objectToSpawn).instantiate(), player.get_grid_position())
