extends Node3D

var aabb: AABB

func _ready() -> void:
	aabb = AABB(global_position - Vector3(1.5, 1.5, 1.5), Vector3(3, 3, 3))
