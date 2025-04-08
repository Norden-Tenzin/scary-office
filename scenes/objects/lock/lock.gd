extends Area3D
class_name Lock

@export var type: GlobalEnums.LockKeyType = GlobalEnums.LockKeyType.Red
@export var _code: int

func unlock(code: int) -> void:
	if code == _code && get_parent().is_in_group("Door"):
		get_parent().unlock()

func lock() -> void:
	if get_parent().is_in_group("Door"):
		get_parent().lock()
