extends RigidBody3D

var locked: bool:
	set(v):
		$"..".locked = v
	get:
		return $"..".locked
