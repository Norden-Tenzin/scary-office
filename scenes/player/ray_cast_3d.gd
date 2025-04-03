extends RayCast3D

var isHoldingObject: bool = false
var held_object: RigidBody3D = null
var distance: float
@onready var marker_last_position: Vector3 = $Marker3D.global_position

func _physics_process(delta: float) -> void:
	hold_object()
	drag_object()
	
func hold_object() -> void:
	if isHoldingObject && Input.is_action_pressed("left_click"):
		return
	elif is_colliding() && get_collider().is_in_group("Door") && Input.is_action_pressed("left_click"):
		if !isHoldingObject:
			isHoldingObject = true
			held_object = get_collider()
	else:
		isHoldingObject = false
		held_object = null


func drag_object() -> void:
	if isHoldingObject:
		#var velocity: Vector3 = $Marker3D.global_position - marker_last_position
		#velocity = velocity.normalized()
		#marker_last_position = $Marker3D.global_position
		#var collision_point: Vector3 = get_collision_point()
		#var new_distance: float = owner.global_position.distance_to(collision_point)
		#if new_distance < distance:
			#print("towards")
			#held_object.apply_central_force(-velocity.length() * held_object.marker.transform.basis.z * 4)
		#else:
			#held_object.apply_central_force(velocity.length() * held_object.marker.transform.basis.z * 4)
			#print("away")
		#distance = new_distance
		var velocity: Vector3 = $Marker3D.global_position - held_object.global_position
		velocity = velocity.normalized()
		held_object.apply_central_force(velocity * 3)
