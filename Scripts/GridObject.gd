extends Sprite2D
class_name GridObject
@onready var grid := get_parent()

func _ready() -> void:
	on_sprite_changed()
	texture_changed.connect(on_sprite_changed)
	
func on_sprite_changed():
	for child in get_children():
		if "shadow" in child.name:
			child.queue_free()
	
	var shadow = Sprite2D.new()
	shadow.name = name + "shadow"
	shadow.texture = texture
	shadow.centered=false
	shadow.z_index = -100
	shadow.flip_v = true
	shadow.skew = 45
	shadow.position.y+=9/scale.x
	shadow.material = load("res://material_shadow.tres")
	if region_enabled:
		shadow.region_enabled = true
		shadow.region_rect = region_rect
	
	add_child(shadow, true)



func get_grid_position() -> Vector2i:
	return (position / (grid.tileSize as Vector2)) as Vector2i

func _exit_tree() -> void:
	if get_grid_position() in grid.grid_objects:
		grid.remove_object(get_grid_position())
