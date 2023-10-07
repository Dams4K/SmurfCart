extends Node3D

@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	mesh_instance_3d.rotate(Vector3(1, .75, .2).normalized(), PI/60)


func _on_area_3d_body_entered(body: Node3D) -> void:
	queue_free()
