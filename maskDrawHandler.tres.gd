extends ColorRect
@export var explored_points = []

func _draw() -> void:
	for point in explored_points:
		draw_circle(point[0]*9, 35, Color(1-point[1], 1-point[1], 1-point[1], 1), true, -1.0, true)

@rpc("any_peer","call_local")
func explore(pos : Vector2i):
	explored_points.append([pos,1.0])
	

func _process(delta: float) -> void:
	queue_redraw()
	for point in explored_points:
		point[1]-=delta/5
		if point[1]<0:
			explored_points.remove_at(explored_points.rfind(point))
