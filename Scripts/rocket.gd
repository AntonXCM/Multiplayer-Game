extends GridObject
@export var passagers = []

@export
var launchTimer = 10.99
var grid_pos
func interact(from: Vector2i):
	grid_pos = get_grid_position()
	if len(passagers)==3:
		return
	var object : GridObject = grid.get_child(grid.grid_objects[from])
	passagers.append(object)
	grid.forget_object(object.get_grid_position())
	grid.remove_child(object)
	get_tree().root.add_child(object)
	object.position = Vector2i(-90,90)
	object.process_mode = Node.PROCESS_MODE_DISABLED
	var visual : Sprite2D = load("res://Pasageer.tscn").instantiate()
	add_child(visual)
	visual.texture = object.texture
	visual.position = Vector2(4,-23+(len(passagers)-1)*8)
	
func _physics_process(delta: float) -> void:
	launchTimer-=delta*len(passagers)
	
	$Text.text = str(int(launchTimer))
	if launchTimer<0:
		launch()
func _process(delta: float) -> void:
	if launchTimer<len(passagers):
		for child in get_children():
			if "shadow" in child.name:
				child.queue_free()
	
		position.y-=(1-launchTimer/len(passagers))*delta*108
func launch():
	grid.remove_object(grid_pos)
	for plr in passagers:
		if plr.is_owned:
			get_tree().root.get_child(0).request_scene("Space")
			print("Улетел")
		plr.queue_free()
