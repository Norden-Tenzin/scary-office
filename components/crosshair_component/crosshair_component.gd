extends Control

const DOT_LARGE = preload("res://assets/cursors/dot_large.svg")
const HAND_CLOSED = preload("res://assets/cursors/hand_closed.svg")
const HAND_OPEN = preload("res://assets/cursors/hand_open.svg")

@onready var sprite: Sprite2D = %Sprite

var curr_state: GlobalEnums.Crosshair = GlobalEnums.Crosshair.Dot

func update_crosshair() -> void:
	match curr_state:
		GlobalEnums.Crosshair.Dot:
			sprite.texture = DOT_LARGE
		GlobalEnums.Crosshair.HandOpen:
			sprite.texture = HAND_OPEN
		GlobalEnums.Crosshair.HandClosed:
			sprite.texture = HAND_CLOSED

# TODO: handle hand close drag maybe
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("left_click"):
		#curr_state = GlobalEnums.Crosshair.HandClosed
		#update_crosshair()
	#if event.is_action_released("left_click"):
		#curr_state = GlobalEnums.Crosshair.Dot
		#update_crosshair()

func _on_ray_cast_component_collision_started() -> void:
	curr_state = GlobalEnums.Crosshair.HandOpen
	update_crosshair()

func _on_ray_cast_component_collision_ended() -> void:
	curr_state = GlobalEnums.Crosshair.Dot
	update_crosshair()
