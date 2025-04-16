class_name WorldState

static func get_player_visible(actor: CharacterBody3D) -> bool:
	var player: CharacterBody3D = Global.player
	if !player:
		return false
	var player_position: Vector3 = player.get_global_transform().origin
	var result: Dictionary = actor.get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(actor.get_global_transform().origin, player_position, 0xFFFFFFFF, [actor]))
	if result && result["collider"] != player:
		return false
	var vec: Vector3 = player.get_global_transform().origin - actor.get_global_transform().origin
	vec = vec.normalized()
	var vec2: Vector3 = -1 * actor.get_global_transform().basis.z.normalized()
	if vec2.dot(vec) < 0.707:
		return false
	return true
