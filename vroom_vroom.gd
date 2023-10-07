extends VehicleBody3D

const MAX_RPM = 2750
const MAX_TORQUE = 750

var phone = OS.has_feature("android")

@onready var phone_control: Control = $PhoneControl

@onready var wheel_back_right: VehicleWheel3D = $WheelBackRight
@onready var wheel_back_left: VehicleWheel3D = $WheelBackLeft
@onready var wheel_front_left: VehicleWheel3D = $WheelFrontLeft
@onready var wheel_front_right: VehicleWheel3D = $WheelFrontRight

@export_group("FrontWheels", "front_")
@export var front_stiffness: float = 5.88
@export var front_max_force: float = 6000.0
@export var front_travel: float = 0.2
@export var front_friction_slip: float = 50.0
@export var front_compression: float = 0.83

@export_group("BackWheels", "back_")
@export var back_stiffness: float = 5.88
@export var back_max_force: float = 6000
@export var back_travel: float = 0.2
@export var back_friction_slip: float = 50.0
@export var back_compression: float = 0.83

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D

func _ready() -> void:
	multiplayer_synchronizer.set_multiplayer_authority(name.to_int())
	
	phone_control.visible = phone
	
	wheel_back_left.suspension_stiffness = back_stiffness
	wheel_back_right.suspension_stiffness = back_stiffness
	wheel_back_left.suspension_max_force = back_max_force
	wheel_back_right.suspension_max_force = back_max_force
	wheel_back_left.suspension_travel = back_travel
	wheel_back_right.suspension_travel = back_travel
	wheel_back_left.wheel_friction_slip = back_friction_slip
	wheel_back_right.wheel_friction_slip = back_friction_slip
	wheel_back_left.damping_compression = back_compression
	wheel_back_right.damping_compression = back_compression
	
	wheel_front_left.suspension_max_force = front_max_force
	wheel_front_right.suspension_max_force = front_max_force
	wheel_front_left.suspension_stiffness = front_stiffness
	wheel_front_right.suspension_stiffness = front_stiffness
	wheel_front_left.suspension_travel = front_travel
	wheel_front_right.suspension_travel = front_travel
	wheel_front_left.wheel_friction_slip = front_friction_slip
	wheel_front_right.wheel_friction_slip = front_friction_slip
	wheel_front_left.damping_compression = front_compression
	wheel_front_right.damping_compression = front_compression

func _physics_process(delta: float) -> void:
	if multiplayer_synchronizer.get_multiplayer_authority() != multiplayer.get_unique_id():
		return
	
	camera_3d.current = true
#	rotation.x = 0
#	print()
	
	
	if !phone:
		steering = lerp(steering, Input.get_axis("right", "left") * .6, 3 * delta)
#		engine_force = Input.get_axis("back", "forward") * 150
		
		var acceleration = Input.get_axis("back", "forward")
		if acceleration < 0:
			acceleration / 2
		
		var rpm = wheel_back_left.get_rpm()
		wheel_back_left.engine_force = acceleration * MAX_TORQUE * (1 - rpm / MAX_RPM)
		rpm = wheel_back_right.get_rpm()
		wheel_back_right.engine_force = acceleration * MAX_TORQUE * (1 - rpm / MAX_RPM)
	else:
		
		steering = lerp(steering, -Input.get_accelerometer().x * .1, 5 * delta)
		
		if PhoneControls.brake:
			engine_force = -75
		elif PhoneControls.forward:
			engine_force = 150
