extends Node3D

@onready var Hit: SpatialAudio3D = $RigidBody3D/CollisionShape3D/MeshInstance3D/Hit


func _on_rigid_body_3d_body_entered(_body: Node) -> void:
	Hit.do_play()
