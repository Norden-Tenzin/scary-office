extends RigidBody3D
class_name FlashLight

@export var enabled: bool = false
@onready var light: SpotLight3D = %Light
@onready var on: AudioStreamPlayer3D = %On
@onready var off: AudioStreamPlayer3D = %Off

func _ready() -> void:
	light.visible = enabled

func interact() -> void:
	match enabled:
		true:
			enabled = false
			light.visible = enabled
			on.play()
		false:
			enabled = true
			light.visible = enabled
			off.play()
