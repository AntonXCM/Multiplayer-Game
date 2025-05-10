extends Node

@onready var chat_log = $ChatLog
@onready var input_field : TextEdit = $InputField

func _ready():
	input_field.text_changed.connect(_on_text_submitted)

func _on_text_submitted():
	if(!input_field.text.contains('\n')):
		return
	if input_field.text.length() < 2:
		return
	display_message.rpc(input_field.text, Connector.playerId)
	input_field.clear()


@rpc("any_peer","call_local")
func display_message(msg,id):
	chat_log.append_text("[%s]: %s" % [Connector.Players[id]["name"], msg])
	Connector.Players[id]["object"].say(msg)
