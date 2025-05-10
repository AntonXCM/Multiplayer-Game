extends Window

@onready var name_input: TextEdit = $NameInput
func _ready():
	if "--server" in OS.get_cmdline_args():
		visible = false
	name_input.grab_focus()
	name_input.text_changed.connect(func ():
		if(name_input.text.ends_with('\n')):
			submit()
		)

func submit():
	var name = name_input.text.strip_edges()
	if name == "":
		_show_error("Имя не может быть пустым")
	elif len(name_input.text)>15:
		_show_error("Не пиши фамилию и отчество ;)")
	else:
		visible = false
		Connector.Name = name
		get_tree().root.get_child(0).join_game()

func _show_error(message: String):
	name_input.clear()
	name_input.placeholder_text = message
	name_input.grab_focus()
