extends Node2D

func _ready() -> void:
	material = load("res://mapMaterial.tres")
	(material as ShaderMaterial).set_shader_parameter("mask", $MaskViewport.get_texture())
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return
	var point = (get_local_mouse_position()/9) as Vector2i
	$MaskViewport/ColorRect.explore.rpc(point)
