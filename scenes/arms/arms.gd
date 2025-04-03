extends Node3D

@onready var remote_left: RemoteTransform3D = %RemoteLeft
@onready var remote_right: RemoteTransform3D = %RemoteRight

func _on_ray_cast_component_interact_hit(collider: Object, with_hand: int) -> void:
	match with_hand: 
		GlobalEnums.Hand.Left:
			interact(remote_left, collider)
		GlobalEnums.Hand.Right:
			interact(remote_right, collider)

func interact(remote: RemoteTransform3D, collider: Object) -> void:
	if collider:
		if collider.is_in_group("PickUpAble"):
			if remote.remote_path == NodePath():
				collider.freeze = true
				remote.set_remote_node(collider.get_path())
		elif collider.is_in_group("Lock"):
			if remote.remote_path != NodePath():
				if get_node(remote.remote_path) is Key:
					var key: Key = get_node(remote.remote_path) as Key
					var lock: Lock = collider as Lock
					if key.type == lock.type:
						# unlock
						lock.unlock()
						# remove key 
						key.queue_free()
						remote.remote_path = NodePath()
	else:
		if remote.remote_path != NodePath():
			if get_node(remote.remote_path) is FlashLight:
				var flash_light: FlashLight = get_node(remote.remote_path) as FlashLight
				flash_light.interact()

func _on_ray_cast_component_drop(with_hand: int) -> void:
	match with_hand: 
		GlobalEnums.Hand.Left:
			if remote_left.remote_path != NodePath():
				var obj: RigidBody3D = get_node(remote_left.remote_path)
				remote_left.remote_path = NodePath()
				obj.freeze = false
				obj.apply_impulse(Vector3.UP * 3)
		GlobalEnums.Hand.Right:
			if remote_right.remote_path != NodePath():
				var obj: RigidBody3D = get_node(remote_right.remote_path)
				remote_right.remote_path = NodePath()
				obj.freeze = false
				obj.apply_impulse(Vector3.UP * 3)
