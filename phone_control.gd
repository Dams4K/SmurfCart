extends Control

@onready var debug_label: Label = %DebugLabel

func _process(delta: float) -> void:
	debug_label.text = str(Input.get_accelerometer())

func _on_forward_button_button_down() -> void:
	PhoneControls.forward = true


func _on_forward_button_button_up() -> void:
	PhoneControls.forward = false


func _on_back_button_button_down() -> void:
	PhoneControls.brake = true


func _on_back_button_button_up() -> void:
	PhoneControls.brake = false


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
