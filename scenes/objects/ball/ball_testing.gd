extends RigidBody3D

@onready var ray_cast: RayCast3D = %RayCast3D
@onready var audio_player: AudioStreamPlayer3D = %AudioStreamPlayer3D

var on_floor: bool = true

func _physics_process(delta: float) -> void:
	# Get the global down direction
	var global_down: Vector3 = Vector3(0, -1, 0)
	# Convert global down to local space
	var local_down: Vector3 = to_local(global_position + global_down) - to_local(global_position)
	# Set the target position
	ray_cast.target_position= local_down.normalized() * 1
	
	if ray_cast.is_colliding():
		if ray_cast.get_collider().is_in_group("Floor"):
			if not on_floor:
				var collision_point: Vector3 = ray_cast.get_collision_point()
				var impact_velocity: float = abs(linear_velocity.y)
				if impact_velocity > 0.:
					#var volume_db: float = clampf(impact_velocity * 0.2, -10.0, 3)
					#audio_player.volume_db = volume_db
					audio_player.play()
				on_floor = true
		else:
			on_floor = false
	else:
		on_floor = false
