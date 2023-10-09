extends Node

func _ready() -> void:
	set_process_input(OS.is_debug_build())

func _input(event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_F12):
		get_tree().reload_current_scene()
