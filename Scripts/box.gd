extends GridObject

func interact(from: Vector2i):
	var to = get_grid_position()
	grid.move_object(to, to+to-from)
	grid.move_object(from, to)
