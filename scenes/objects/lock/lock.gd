extends RigidBody3D
class_name Lock

@export var type: GlobalEnums.LockKeyType = GlobalEnums.LockKeyType.Red
var unlocked: bool = false

func unlock() -> void:
	unlocked = true
