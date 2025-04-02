extends Node3D

@onready var remote_left: RemoteTransform3D = %RemoteLeft
@onready var remote_right: RemoteTransform3D = %RemoteRight

func _on_pick_up_component_item_picked_up(node_path: NodePath, with_hand: GlobalEnums.Hand) -> void:
	match with_hand: 
		GlobalEnums.Hand.Left:
			remote_left.set_remote_node(node_path)
		GlobalEnums.Hand.Right:
			remote_right.set_remote_node(node_path)

func _on_pick_up_component_item_dropped(with_hand: GlobalEnums.Hand) -> void:
	match with_hand: 
		GlobalEnums.Hand.Left:
			var obj: RigidBody3D = get_node(remote_left.remote_path)
			print("OBJ")
			print(obj)
			remote_left.remote_path = NodePath()
			obj.freeze = false
			obj.apply_impulse(Vector3.UP * 3)
		GlobalEnums.Hand.Right:
			var obj: RigidBody3D = get_node(remote_right.remote_path)
			remote_right.remote_path = NodePath()
			obj.freeze = false
			obj.apply_impulse(Vector3.UP * 3)
