extends Window

@onready var server_input: TextEdit = $ServarInput
@onready var port_input: TextEdit = $PortInput
@onready var name_input: TextEdit = $NameInput

@onready var connector: Connector = get_tree().root.get_child(0)
func _ready():
	if "--server" in OS.get_cmdline_args():
		visible = false
	name_input.grab_focus()
	name_input.text_changed.connect(func ():
		if(name_input.text.ends_with('\n')):
			submit()
		)
	port_input.text_changed.connect(func ():
		if(port_input.text.ends_with('\n')):
			submit()
		)
	server_input.text_changed.connect(func ():
		if(server_input.text.ends_with('\n')):
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
		connector.Name = name
		connector.Address = server_input.text.strip_edges()
		connector.port = int(port_input.text.strip_edges())
		connector.join_game()

func _show_error(message: String):
	name_input.clear()
	name_input.placeholder_text = message
	name_input.grab_focus()
