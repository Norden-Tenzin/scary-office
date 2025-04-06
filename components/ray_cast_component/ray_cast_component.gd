extends RayCast3D
class_name RayCastComponent

@export var head: Node3D
@export var camera: Camera3D

func _ready() -> void:
	self.position = head.position

func _process(delta: float) -> void:
	self.position = head.position
	self.rotation.y = head.rotation.y
	self.rotation.x = camera.rotation.x
