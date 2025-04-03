extends Node3D

@export var sway: bool = false
@export var head: Node3D
@export var camera: Camera3D
@export var hands: Node3D

var head_y_axis: float = 0.0
var camera_x_axis: float = 0.0

@export var SENSITIVITY: float = 0.01
@export var CAMERA_ACCELERATION: float = 6

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if sway:
			# Left Right
			head_y_axis += event.relative.x * SENSITIVITY
			var raw_target_rotation: float = -deg_to_rad(head_y_axis)
			var current_rotation: float = head.rotation.y
			var rotation_difference: float = raw_target_rotation - current_rotation
			rotation_difference = fposmod(rotation_difference + PI, 2 * PI) - PI
			var max_rotation_change: float = deg_to_rad(90)
			var clamped_difference: float = clamp(rotation_difference, -max_rotation_change, max_rotation_change)
			var constrained_target: float = current_rotation + clamped_difference
			head_y_axis = -rad_to_deg(constrained_target)
			
			# Up Down
			camera_x_axis += event.relative.y * SENSITIVITY
			camera_x_axis = clamp(camera_x_axis, -90, 180)
		else:
			head_y_axis += event.relative.x * SENSITIVITY
			camera_x_axis += event.relative.y * SENSITIVITY
			camera.transform.basis = Basis()
			head.transform.basis = Basis()
			head.rotate_object_local(Vector3(0, 1, 0), -head_y_axis)
			camera_x_axis = clamp(camera_x_axis, deg_to_rad(-90), deg_to_rad(90))
			camera.rotate_object_local(Vector3(1, 0, 0), -camera_x_axis)
			hands.transform.basis = Basis()
			hands.rotate_object_local(Vector3(0, 1, 0), -head_y_axis)
			hands.rotate_object_local(Vector3(1, 0, 0), -camera_x_axis)

func _process(delta: float) -> void:
	if sway:
		head.rotation.y = lerp_angle(head.rotation.y, -deg_to_rad(head_y_axis), CAMERA_ACCELERATION * delta)
		camera.rotation.x = lerp_angle(camera.rotation.x, -deg_to_rad(camera_x_axis), CAMERA_ACCELERATION * delta)
		hands.rotation.y = lerp_angle(hands.rotation.y, -deg_to_rad(head_y_axis), CAMERA_ACCELERATION * 4 * delta)
		hands.rotation.x = lerp_angle(hands.rotation.x, -deg_to_rad(camera_x_axis), CAMERA_ACCELERATION * 4 * delta)
