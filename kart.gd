extends Node3D

var gravity = ProjectSettings.get("physics/3d/default_gravity")

@export var MAX_SPEED = 30

@onready var ray_cast_3d: RayCast3D = $RayCast3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

func _process(delta: float) -> void:
	if ray_cast_3d.is_colliding():
		position.y =  ray_cast_3d.get_collision_point().y + 1
		
		# Not working yet
#		var angle_to_floor = ray_cast_3d.get_collision_normal().angle_to(Vector3.UP)
#		mesh_instance_3d.rotation.z = angle_to_floor
	else:
		position.y -= gravity * delta
	
	
	var acceleration = Input.get_axis("back", "forward")
	var direction = Input.get_axis("right", "left")
	
	rotate(Vector3.UP, direction * PI/128)
	
	var pos: Vector3 = Vector3.MODEL_FRONT.rotated(Vector3.UP, rotation.y+PI/2) * (acceleration * MAX_SPEED * delta)
	position.x += pos.x
	position.z += pos.z
