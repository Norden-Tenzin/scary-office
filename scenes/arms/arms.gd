extends Node3D

@onready var remote_left: RemoteTransform3D = %RemoteLeft
@onready var remote_right: RemoteTransform3D = %RemoteRight
var isHoldingObject: bool = false
var held_object: RigidBody3D = null

func _on_ray_cast_component_interact_hit(collider: Object, with_hand: int, other: Dictionary) -> void:
	match with_hand: 
		GlobalEnums.Hand.Left:
			interact(remote_left, collider, other)
		GlobalEnums.Hand.Right:
			interact(remote_right, collider, other)

func interact(remote: RemoteTransform3D, collider: Object, other: Dictionary) -> void:
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
	hold_object(collider)
	drag_object(other["marker_position"])

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

func drag_object(marker_position: Vector3) -> void:
	if isHoldingObject:
			var velocity: Vector3 = marker_position - held_object.global_position
			velocity = velocity.normalized()
			held_object.apply_central_force(velocity * 7)
		
func hold_object(collider: Object) -> void:
	if isHoldingObject:
		return
	elif collider.is_in_group("Door"):
		if !isHoldingObject:
			isHoldingObject = true
			held_object = collider
	else:
		isHoldingObject = false
		held_object = null
