extends Button

func _pressed() -> void:
	get_tree().root.get_child(0).request_scene("Planet")
