extends Node3D

@export var head: Node3D
@export var camera: Camera3D
@export var SENSITIVITY: float = 0.01

var rot_x: float = 0
var rot_y: float = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rot_x += event.relative.x * SENSITIVITY
		rot_y += event.relative.y * SENSITIVITY
		camera.transform.basis = Basis()
		head.transform.basis = Basis()
		head.rotate_object_local(Vector3(0, 1, 0), -rot_x)
		rot_y = clamp(rot_y, deg_to_rad(-90), deg_to_rad(90))
		camera.rotate_object_local(Vector3(1, 0, 0), -rot_y)
