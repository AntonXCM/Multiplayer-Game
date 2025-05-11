extends Control
class_name Connector

@export var Address = "localhost"
@export var port = 5352
@export var playerPrefab : PackedScene
static var peer
static var upnp
static var playerId : int = 0
static var Players = {}
static var PlayerSkins = {}
static var Scene
static var SceneNode
static var Name
var scenes = {}

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	if !("--server" in OS.get_cmdline_args()):
		return
	hostGame()
	create_scene("Planet","res://Planet.tscn")
	create_scene("Space","res://map.tscn")
	upnp = UPNP.new()
	upnp.discover()
	upnp.add_port_mapping(port, port, "Multiplayer Game","TCP")
	get_window().title="Host"

func create_scene(sceneName:String, resource:String):
	var scene : Node2D = (load(resource) as PackedScene).instantiate()
	scene.name = sceneName
	scenes[sceneName] = scene
	scene.position.x += (len(scenes)-1)*1000
	scene.set_multiplayer_authority(0)
	get_tree().root.add_child.call_deferred(scene)

func peer_connected(id : int):
	print("Player Connected " + str(id))
	
func peer_disconnected(id):
	print("Player Disconnected " + str(id))
	Players[id]["object"].queue_free()
	Players.erase(id)

func connected_to_server():
	playerId = multiplayer.get_unique_id()
	SendPlayerInformation.rpc_id(0, Name, playerId)
	request_scene("Planet")

func connection_failed():
	print("Couldnt Connect")

@rpc("any_peer", "reliable")
func SendPlayerInformation(nickname, id):
	if !Players.has(id):
		Players[id] ={
			"name" : nickname,
			"id" : id
		}

func request_scene(sceneName:String):
	send_player_to_scene.rpc(sceneName,playerId)
	Scene = sceneName
	if !multiplayer.is_server():
		Players.clear()
	
@rpc("any_peer","call_remote")
func send_player_to_scene(sceneName: String, id: int):
	if multiplayer.is_server():
		if Players[id].has("object"):
			Players[id]["object"].queue_free()
		Players[id]["scene"] = sceneName
		for i in Players.values():
			var scene = i["scene"]
			
			if scene == sceneName:
				SendPlayerInformation.rpc_id(id,i["name"], i["id"])
				SendPlayerInformation.rpc_id(i["id"],Players[id]["name"], id)
		var playerScene = (scenes[sceneName] as Node)
		send_scene_bytes.rpc_id(id, NetworkSerializer.serialize(playerScene))
		for player in Players.values():
			if player["id"] == id:
				continue
			rpc_set_skin.rpc_id(id, var_to_bytes_with_objects(player["object"].texture),player["id"])
		var player = playerPrefab.instantiate()
		player.name = "Player " + str(id)
		player.set_id(id)
		playerScene.rpc_place_object_anywhere(player)

@rpc("reliable")
func send_scene_bytes(data: PackedByteArray):
	if SceneNode:
		SceneNode.queue_free()
	SceneNode = NetworkSerializer.deserialize(data)
	get_tree().root.add_child(SceneNode)

func hostGame():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 4095)
	if error != OK:
		print("cannot host: " + str(error))
		return
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)
	print("Захостил")

func join_game():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(Address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_NONE)
	multiplayer.set_multiplayer_peer(peer)

func set_skin(image):
	rpc_set_skin.rpc(var_to_bytes_with_objects(image), playerId)

@rpc("any_peer","call_local")
func rpc_set_skin(image : PackedByteArray, id : int):
	var skin = bytes_to_var_with_objects(image)
	var size = skin.get_size()
	PlayerSkins[id] = image
	Players[id]["object"].scale = Vector2(9,9)/size
	Players[id]["object"].texture = skin
