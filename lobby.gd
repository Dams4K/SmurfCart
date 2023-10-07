extends VBoxContainer

@onready var player_container: VBoxContainer = %PlayerContainer
@onready var start_game_button: Button = %StartGameButton

func _ready() -> void:
	for player_id in MultiplayerManager.players:
		update_player_informations(player_id)
	MultiplayerManager.new_player_informations.connect(_on_new_player_informations)
	MultiplayerManager.player_disconnected.connect(_on_player_disconnect)
	
	start_game_button.visible = multiplayer.is_server()


func _on_new_player_informations(player_id: int) -> void:
	update_player_informations(player_id)


func update_player_informations(player_id: int) -> void:
	var player_node = player_container.get_node_or_null(str(player_id))
	
	if player_node == null:
		player_node = Label.new()
		player_node.name = str(player_id)
		player_container.add_child(player_node)
	
	player_node.text = MultiplayerManager.players[player_id].name


func _on_player_disconnect(player_id: int) -> void:
	var player_node = player_container.get_node_or_null(str(player_id))
	if player_node:
		player_node.queue_free()


func _on_start_game_button_pressed() -> void:
	start_game.rpc()

@rpc("authority", "call_local")
func start_game():
	print("start")
	get_tree().change_scene_to_file("res://main.tscn")
