extends RayCast3D
class_name RayCastComponent

@export var head: Node3D
@export var camera: Camera3D
@export var length: float

func _ready() -> void:
	self.position = head.position
	target_position = Vector3(0, 0, -length)

func _process(delta: float) -> void:
	self.position = head.position
	self.rotation.y = head.rotation.y
	self.rotation.x = camera.rotation.x

func get_marker_position() -> Vector3:
	return $Marker3D.global_position
