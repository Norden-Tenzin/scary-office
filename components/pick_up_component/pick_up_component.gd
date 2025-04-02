# Ideally I would have liked to split this into ray_cast_component and pick_up_component
extends Node3D

signal collision_started
signal collision_ended

signal item_picked_up(node_path: NodePath, with_hand: GlobalEnums.Hand)
signal item_dropped(with_hand: GlobalEnums.Hand)

@export var camera: Node3D
@export var pick_up_range: float = 100.0
@export var hands: Node3D

var ray_cast: RayCast3D
var was_colliding: bool = false
var last_collider: Object = null

func _ready() -> void:
	ray_cast = RayCast3D.new()
	ray_cast.collide_with_bodies = true
	ray_cast.collide_with_areas = true
	ray_cast.hit_from_inside = true
	ray_cast.set_collision_mask_value(1, false)
	ray_cast.set_collision_mask_value(2, true)
	ray_cast.target_position = -camera.transform.basis.z.normalized() * pick_up_range
	camera.add_child(ray_cast)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		pick_up_item(GlobalEnums.Hand.Left)
	if Input.is_action_just_pressed("right_click"):
		pick_up_item(GlobalEnums.Hand.Right)
	# TODO: Add to input
	if Input.is_action_just_pressed("drop_left"):
		drop_item(GlobalEnums.Hand.Left)
	if Input.is_action_just_pressed("drop_right"):
		drop_item(GlobalEnums.Hand.Right)
	
	# Crosshair handler
	# raycast hit something and was not hitting something before
	if ray_cast.is_colliding() and not was_colliding:
		last_collider = ray_cast.get_collider()
		collision_started.emit()
	# raycast hit something and was hitting something
	# (edge case: where the player goes from one item to the next)
	# TODO: how to handle this same signal as started?
	if ray_cast.is_colliding() and was_colliding:
		if last_collider != ray_cast.get_collider():
			last_collider = ray_cast.get_collider()
			collision_started.emit()
	# raycast stopped hitting something and was hitting something
	elif not ray_cast.is_colliding() and was_colliding:
		collision_ended.emit()
	was_colliding = ray_cast.is_colliding()

func pick_up_item(hand: GlobalEnums.Hand) -> void:
	if ray_cast.is_colliding():
		if ray_cast.get_collider().is_in_group("PickUpAble"):
			ray_cast.get_collider().freeze = true
			item_picked_up.emit(ray_cast.get_collider().get_path(), hand)

func drop_item(hand: GlobalEnums.Hand) -> void:
	item_dropped.emit(hand)
