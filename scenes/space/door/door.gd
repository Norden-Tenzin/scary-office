extends Node3D
class_name Door

func _ready() -> void:
	var main_scene_children: Array
	var positions: Array
	for child in get_children():
		if child.owner != self:
			main_scene_children.append(child)
			positions.append(child.global_position)

	var i: int = 0
	for child: Object in main_scene_children:
		remove_child(child)
		$RigidBody3D.add_child(child)
		child.global_position = positions[i]
		i += 1

func unlock() -> void:
	print("unlocked")
	
func lock() -> void:
	print("locked")
