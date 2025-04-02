extends Node3D

signal item_picked_up(node_path: NodePath, with_hand: GlobalEnums.Hand)
signal item_dropped(node_path: NodePath, with_hand: GlobalEnums.Hand)

@export var camera: Node3D
@export var pick_up_range: float = 100.0
@export var hands: Node3D

var ray_cast: RayCast3D

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

func pick_up_item(hand: GlobalEnums.Hand) -> void:
	if ray_cast.is_colliding():
		if ray_cast.get_collider().is_in_group("PickUpAble"):
			ray_cast.get_collider().freeze = true
			item_picked_up.emit(ray_cast.get_collider().get_path(), hand)
