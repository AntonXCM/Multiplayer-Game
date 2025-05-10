extends Sprite2D

var fuse = 1.0

func _process(delta: float) -> void:
	fuse-=delta
	if fuse < 0:
		for child in get_parent().get_children():
			try_destroy(child)
		var grid = get_parent().get_parent()
		for tile in grid.grid_objects.values():
			try_destroy(grid.get_child(tile))
func try_destroy(node:Node2D):
	if ((position-node.position)/9).length_squared() <= 2.5:
		if node.name.begins_with("Player"):
			node.get_parent().move_object(node.get_grid_position(),node.get_grid_position()+(position as Vector2i))
		else:
			node.queue_free()
