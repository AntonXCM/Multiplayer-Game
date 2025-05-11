extends Control
@export var player : AudioStreamPlayer2D
@onready var file_dialog = $FileDialog

func _on_pressed() -> void:
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.ogg","Music")
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	file_dialog.popup_centered()

func _on_file_selected(path : String):
	load_music.rpc(var_to_bytes_with_objects(AudioStreamOggVorbis.load_from_file(path)))
	
@rpc("any_peer", "call_local","reliable")
func load_music(music:PackedByteArray):
	
	player.stream = bytes_to_var_with_objects(music)
	player.play()
