extends Node2D
@export var size: Rect2i
@export var tileSize: Vector2i
@export var grid_objects = {}

@rpc("any_peer", "call_local")
func place_object(bytes: PackedByteArray, grid_pos: Vector2i):
	grid_pos = clamp_in_grid(grid_pos)
	if grid_objects.has(grid_pos):
		grid_pos = find_nearest_free_tile(grid_pos)
		if grid_pos == Vector2i(-1, -1):
			return
	var obj = NetworkSerializer.deserialize(bytes)
	add_child.call_deferred(obj)
	grid_objects[grid_pos] = get_child_count()
	obj.position = grid_pos * tileSize

@rpc("any_peer", "call_local")
func move_object(from: Vector2i, to: Vector2i):
	to = clamp_in_grid(to)
	if not grid_objects.has(from):
		push_error("Invalid move")
		return
	if grid_objects.has(to):
		if get_child(grid_objects[to]).has_method("interact"):
			get_child(grid_objects[to]).interact(from)
			return
		else:
			to = find_nearest_free_tile(to)
			if to == -Vector2i.ONE:
				return
	var obj = grid_objects[from]
	grid_objects.erase(from)
	grid_objects[to] = obj
	get_child(obj).position = to * tileSize

@rpc("any_peer", "call_local")
func remove_object(grid_pos: Vector2i):
	if not grid_objects.has(grid_pos):
		push_error("No object at position")
		return
	get_child(grid_objects[grid_pos]).queue_free()
	forget_object(grid_pos)

@rpc("any_peer", "call_local")
func forget_object(grid_pos: Vector2i):
	if not grid_objects.has(grid_pos):
		push_error("No object at position")
		return
	var index = grid_objects[grid_pos];
	for key in grid_objects.keys():
		if grid_objects[key] > index:
			grid_objects[key]-=1
		
	grid_objects.erase(grid_pos)

func find_nearest_free_tile(origin: Vector2i) -> Vector2i:
	var max_radius = 10  # ограничение на поиск
	for r in range(1, max_radius + 1):
		for x in range(-r, r + 1):
			for y in range(-r, r + 1):
				if abs(x) != r and abs(y) != r:
					continue
				var pos = clamp_in_grid(origin + Vector2i(x, y))
				if not grid_objects.has(pos):
					return pos
	return Vector2i(-1, -1)  # не найдено

func clamp_in_grid(pos: Vector2i) -> Vector2i:
	while pos.x < size.position.x:
		pos.x += size.size.x
	while pos.y < size.position.y:
		pos.y += size.size.y 
	while pos.x >= size.end.x:
		pos.x -= size.size.x 
	while pos.y >= size.end.y:
		pos.y -= size.size.y 
	return pos

func get_object_at(pos: Vector2i) -> Node2D:
	return grid_objects.get(pos)

func rpc_place_object(obj: Node, grid_pos: Vector2i):
	print("placing" + obj.name)
	place_object.rpc.call_deferred(NetworkSerializer.serialize(obj), grid_pos)

func rpc_place_object_anywhere(obj: Node):
	var pos = Vector2i(randi_range(size.position.x,size.end.x),randi_range(size.position.y,size.end.y))
	while grid_objects.has(pos):
		pos = Vector2i(randi_range(size.position.x,size.end.x),randi_range(size.position.y,size.end.y))
	rpc_place_object(obj,pos)




func rpc_move_object(from: Vector2i, to: Vector2i):
	move_object.rpc(from, to)

func rpc_remove_object(grid_pos: Vector2i):
	remove_object.rpc(grid_pos)
