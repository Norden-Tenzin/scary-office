extends RayCast3D

signal collision_started
signal collision_ended

signal interact_hit(collider: Object, with_hand: GlobalEnums.Hand)
signal drop(with_hand: GlobalEnums.Hand)

var was_colliding: bool = false
var last_collider: Object = null

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		var collider: Object = check_collision()
		if collider is Object:
			interact_hit.emit(collider, GlobalEnums.Hand.Left)
	if Input.is_action_just_pressed("right_click"):
		var collider: Object = check_collision()
		if collider is Object:
			interact_hit.emit(collider, GlobalEnums.Hand.Right)
	# TODO: Add handle drop
	if Input.is_action_just_pressed("drop_left"):
		drop.emit(GlobalEnums.Hand.Left)
	if Input.is_action_just_pressed("drop_right"):
		drop.emit(GlobalEnums.Hand.Right)
	
	# Crosshair handler
	# raycast hit something and was not hitting something before
	if is_colliding() and not was_colliding:
		last_collider = get_collider()
		collision_started.emit()
	# raycast hit something and was hitting something
	# (edge case: where the player goes from one item to the next)
	# TODO: how to handle this same signal as started?
	if is_colliding() and was_colliding:
		if last_collider != get_collider():
			last_collider = get_collider()
			collision_started.emit()
	# raycast stopped hitting something and was hitting something
	elif not is_colliding() and was_colliding:
		collision_ended.emit()
	was_colliding = is_colliding()

func check_collision() -> Object:
	if is_colliding():
		return get_collider()
	return null
	
