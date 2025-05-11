extends Control
@export var connector : Connector
@onready var file_dialog = $FileDialog

func _on_pressed() -> void:
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.add_filter("*.png ; PNG Images")
	file_dialog.connect("file_selected", Callable(self, "_on_file_selected"))
	file_dialog.popup_centered()

func _on_file_selected(path):
	var image = Image.new()
	if image.load(path) != OK:
		$WrongDialog.popup()
		return
	var texture = ImageTexture.create_from_image(image)
	connector.set_skin(texture)
	
