extends RigidBody3D

func unlock() -> void:
	freeze = false
	$"..".unlock()
	
func lock() -> void:
	if rad_to_deg(rotation.y) < 0.1:
		freeze = true
		$"..".lock()
