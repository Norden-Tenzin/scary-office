## this does the job of multiple components
## 1. RayCastComponent
## 2. PickUpComponent
## 3. InteractComponent
## Ideally I would have liked to split this up
#
extends Node3D
#
#signal collision_started
#signal collision_ended
#
#signal item_picked_up(node_path: NodePath, with_hand: GlobalEnums.Hand)
#signal item_dropped(with_hand: GlobalEnums.Hand)
#
#@export var camera: Node3D
#@export var pick_up_range: float = 100.0
#
#func pick_up_item(hand: GlobalEnums.Hand) -> void:
	#if ray_cast.is_colliding():
		#if ray_cast.get_collider().is_in_group("PickUpAble"):
			#ray_cast.get_collider().freeze = true
			#item_picked_up.emit(ray_cast.get_collider().get_path(), hand)
#
#func drop_item(hand: GlobalEnums.Hand) -> void:
	#item_dropped.emit(hand)
