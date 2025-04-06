extends Node3D

@export var ray_cast: RayCastComponent

@onready var remote_left: RemoteTransform3D = %RemoteLeft
@onready var remote_right: RemoteTransform3D = %RemoteRight

func interact(remote: RemoteTransform3D, collider: Object) -> void:
	if collider:
		if collider.is_in_group("PickUpAble"):
			if remote.remote_path == NodePath():
				collider.freeze = true
				remote.set_remote_node(collider.get_path())
		elif collider.is_in_group("Lock"):
			if remote.remote_path != NodePath():
				if get_node(remote.remote_path) is Keycard and collider is Lock:
					var key: Keycard = get_node(remote.remote_path) as Keycard
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

func drop(remote: RemoteTransform3D) -> void:
	if remote.remote_path != NodePath():
		var obj: RigidBody3D = get_node(remote.remote_path)
		remote.remote_path = NodePath()
		obj.freeze = false
		# DROP
		#obj.apply_impulse(Vector3.UP * 3)
		# THROW
		var impulse_vector: Vector3 = -self.global_transform.basis.z * 10  # Replace force_magnitude with your desired value
		obj.apply_impulse(impulse_vector, self.position)

func _on_input_component_click(action: int) -> void:
	match action: 
		GlobalEnums.ActionInput.LeftClick:
			var collider: Object = check_collision()
			interact(remote_left, collider)
		GlobalEnums.ActionInput.RightClick:
			var collider: Object = check_collision()
			interact(remote_right, collider)

func _on_input_component_drop(action: int) -> void:
	match action:
		GlobalEnums.ActionInput.DropLeft:
			drop(remote_left)
		GlobalEnums.ActionInput.DropRight:
			drop(remote_right)

func check_collision() -> Object:
	if ray_cast.is_colliding():
		return ray_cast.get_collider()
	return null
