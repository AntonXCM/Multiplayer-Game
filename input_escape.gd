extends TextEdit

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (get_local_mouse_position().y<0 or get_local_mouse_position().x>size.x):
		editable = false
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		editable = true
