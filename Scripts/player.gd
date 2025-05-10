extends GridObject

@export var direction := Vector2i.ZERO
@export var id = 1;
const MOVEMENT_KEYS := {KEY_W: Vector2i.UP, KEY_A: Vector2i.LEFT, KEY_S: Vector2i.DOWN, KEY_D: Vector2i.RIGHT}
var is_owned = false

func _enter_tree() -> void:
	if id == 0:
		self.texture=load("res://tgianter.png")
	Connector.Players[id]["object"] = self
	if id == Connector.playerId:
		is_owned = true

func set_id(Id):
	id = Id

func _input(event):
	if !is_owned:
		return
	if event is InputEventKey:
		var dir = MOVEMENT_KEYS.get(event.keycode)
		if event.pressed and dir:
			direction = dir
		elif not event.pressed and direction == dir:
			direction = Vector2i.ZERO

func _physics_process(_delta):
	if direction:
		$RichTextLabel.text = ""
		grid.rpc_move_object(get_grid_position(), get_grid_position() + direction)

func say(msg):
	$RichTextLabel.text = msg
