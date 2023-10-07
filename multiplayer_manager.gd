extends Node

signal new_player_connected(id: int)
signal new_player_informations(id: int)
signal player_disconnected(id: int)

var peer: ENetMultiplayerPeer

var players = {}

var player_name: StringName = ""

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)


func create_client(addr: String, port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(addr, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer


func create_server(port: int) -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	if error != OK:
		print("cannot host: " + error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer


func _on_player_connected(id: int):
#	print("Player %d connected" % id)
	new_player_connected.emit(id)

func _on_player_disconnected(id: int):
#	print("Player %d disconnected" % id)
	player_disconnected.emit(id)
	remove_player_informations(id)

@rpc("any_peer")
func send_player_informations(player_id: int, player_name: String):
	if !players.has(player_id):
		players[player_id] = {
			"name": player_name
		}
	new_player_informations.emit(player_id)
	
	if multiplayer.is_server():
		for i in players:
			send_player_informations.rpc(i, players[i].name)

@rpc("any_peer")
func remove_player_informations(player_id: int):
	players.erase(player_id)
