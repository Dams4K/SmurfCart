extends Node3D

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	for id in MultiplayerManager.players:
		var player = player_scene.instantiate()
		player.name = str(id)
		add_child(player)
		player.position.y = 1
		player.position.x = randi_range(-100, 100)
		player.position.z = randi_range(-100, 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
