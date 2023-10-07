extends CenterContainer

@export var addr: StringName = "127.0.0.1"
@export var port: int = 4343

@onready var addr_line_edit: LineEdit = %AddrLineEdit
@onready var port_line_edit: LineEdit = %PortLineEdit

@onready var name_line_edit: LineEdit = %NameLineEdit

func _ready() -> void:
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)


func _on_host_button_pressed() -> void:
#	print("host")
	MultiplayerManager.create_server(int(port_line_edit.text))
	MultiplayerManager.send_player_informations(multiplayer.get_unique_id(), name_line_edit.text)
	get_tree().change_scene_to_file("res://lobby.tscn")


func _on_join_button_pressed() -> void:
#	print("join")
	MultiplayerManager.create_client(addr_line_edit.text, int(port_line_edit.text))


func connected_to_server():
#	print("connected")
	MultiplayerManager.send_player_informations.rpc_id(1, multiplayer.get_unique_id(), name_line_edit.text)
	get_tree().change_scene_to_file("res://lobby.tscn")

func connection_failed():
	print("connection failed")


#func _on_button_pressed() -> void:
#	start_game.rpc()


#@rpc("authority", "call_local")
#func start_game():
#	print("start")
#	print(GameManager.players)
#	get_tree().change_scene_to_file("res://main.tscn")
