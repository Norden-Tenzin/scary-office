extends NavigationAgent3D

func _physics_process(delta: float) -> void:
	target_position = $"../../target".global_position
	get_next_path_position()
	
func _input(e: InputEvent) -> void:
	if Input.is_action_just_pressed("rebake"):
		#set_navigation_layer_value(2, !get_navigation_layer_value(2))
		$"../../Door/NavigationRegion3D".enabled = !$"../../Door/NavigationRegion3D".enabled
