extends Area3D
class_name Lock

@export var type: GlobalEnums.LockKeyType = GlobalEnums.LockKeyType.Red
@export var _code: int
var door: Object

func _ready() -> void:
	door = get_parent()

func insert_card(card: Keycard) -> void:
	$RemoteTransform3D.set_remote_node(card.get_path())

func lock_switch() -> void:
	if get_node($RemoteTransform3D.get_remote_node()).code == _code:
		door.locked = !door.locked
