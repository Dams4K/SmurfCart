extends VehicleBody3D

const MAX_RPM = 2750
const MAX_TORQUE = 750
const MAX_STEER = 0.4
const STEER_SPEED = 1.5

var phone = OS.has_feature("android")

@onready var phone_control: Control = $PhoneControl

@onready var wheel_back_right: VehicleWheel3D = $WheelBackRight
@onready var wheel_back_left: VehicleWheel3D = $WheelBackLeft
@onready var wheel_front_left: VehicleWheel3D = $WheelFrontLeft
@onready var wheel_front_right: VehicleWheel3D = $WheelFrontRight

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var player_name: Label3D = $PlayerName

func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(name.to_int())
	player_name.text = MultiplayerManager.players[name.to_int()].name
	if multiplayer_synchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		player_name.hide()
	
	phone_control.visible = phone

func _process(delta: float) -> void:
	player_name.look_at(get_viewport().get_camera_3d().global_position, Vector3.UP, true)

func _physics_process(delta: float) -> void:
	if multiplayer_synchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	camera_3d.current = true
	
	var acceleration: float = 0
	if !phone:
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * STEER_SPEED)
		
		acceleration = Input.get_axis("back", "forward")
	else:
		steering = lerp(steering, -Input.get_accelerometer().x / 5 * MAX_STEER, delta * STEER_SPEED)
		
		if PhoneControls.brake:
			acceleration = -1
		elif PhoneControls.forward:
			acceleration = 1
	
	
	if acceleration < 0:
		acceleration / 2
		
	var rpm = wheel_back_left.get_rpm()
	wheel_back_left.engine_force = acceleration * MAX_TORQUE * (1 - rpm / MAX_RPM)
	rpm = wheel_back_right.get_rpm()
	wheel_back_right.engine_force = acceleration * MAX_TORQUE * (1 - rpm / MAX_RPM)
