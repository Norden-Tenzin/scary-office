extends Node3D

@onready var remote_left: RemoteTransform3D = %RemoteLeft
@onready var remote_right: RemoteTransform3D = %RemoteRight
@export var ray_cast: RayCast3D

var isHoldingObjectLeft: bool = false
var held_object: RigidBody3D = null
var collider: Object = null


func interact(remote: RemoteTransform3D, with_hand: int) -> void:
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
				
				
func _physics_process(delta: float) -> void:
	if ray_cast.is_colliding():
		collider = ray_cast.get_collider()
	else:
		collider = null
	drag_object()
				


func drag_object() -> void:
	if isHoldingObjectLeft:
			var velocity: Vector3 = ray_cast.get_marker_position() - held_object.global_position
			velocity = velocity.normalized()
			held_object.apply_central_force(velocity * 7)
		
func hold_object(collider: Object) -> void:
	if collider && collider.is_in_group("Door"):
		isHoldingObjectLeft = true
		held_object = collider


func _on_input_component_click(what: String) -> void:
	match what: 
		"left_click":
			interact(remote_left, GlobalEnums.Hand.Left)
		"right_click":
			interact(remote_right, GlobalEnums.Hand.Right)


func _on_input_component_drag_started(what: String) -> void:
	hold_object(collider)


func _on_input_component_let_go(what: String) -> void:
	if what == "left_click":
		isHoldingObjectLeft = false
