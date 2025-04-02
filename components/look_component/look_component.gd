extends Node3D

@export var head: Node3D
@export var camera: Camera3D
@export var hands: Node3D

var head_y_axis: float = 0.0
var camera_x_axis: float = 0.0

@export var SENSITIVITY: float = 0.25
@export var CAMERA_ACCELERATION: float = 2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head_y_axis += event.relative.x * SENSITIVITY
		
		var raw_target_rotation: float = -deg_to_rad(head_y_axis)
		var current_rotation: float = head.rotation.y
		
		var rotation_difference: float = raw_target_rotation - current_rotation
		rotation_difference = fposmod(rotation_difference + PI, 2 * PI) - PI
		var max_rotation_change: float = deg_to_rad(90)
		var clamped_difference: float = clamp(rotation_difference, -max_rotation_change, max_rotation_change)
		var constrained_target: float = current_rotation + clamped_difference
		head_y_axis = -rad_to_deg(constrained_target)
		camera_x_axis += event.relative.y * SENSITIVITY
		camera_x_axis = clamp(camera_x_axis, -40, 80)

func _process(delta: float) -> void:
	head.rotation.y = lerp_angle(head.rotation.y, -deg_to_rad(head_y_axis), CAMERA_ACCELERATION * delta)
	camera.rotation.x = lerp(camera.rotation.x, -deg_to_rad(camera_x_axis), CAMERA_ACCELERATION * delta)
	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(85))
	
	hands.rotation.y = -deg_to_rad(head_y_axis)
	hands.rotation.x = -deg_to_rad(camera_x_axis)
