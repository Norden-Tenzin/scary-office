extends CharacterBody3D
class_name Player

signal on_crouch(is_crouched: bool)

var is_crouched: bool = false

func _on_input_component_crouch() -> void:
	is_crouched = !is_crouched
	on_crouch.emit(is_crouched)
