extends Control

const DOT_LARGE = preload("res://assets/cursors/dot_large.svg")
const HAND_CLOSED = preload("res://assets/cursors/hand_closed.svg")
const HAND_OPEN = preload("res://assets/cursors/hand_open.svg")

@export var ray_cast: RayCastComponent

@onready var sprite: Sprite2D = %Sprite

var curr_state: GlobalEnums.Crosshair = GlobalEnums.Crosshair.Dot
var was_colliding: bool = false
var last_collider: Object = null

func _physics_process(delta: float) -> void:
	# Crosshair handler
	# raycast hit something and was not hitting something before
	if ray_cast.is_colliding() and not was_colliding:
		last_collider = ray_cast.get_collider()
		curr_state = GlobalEnums.Crosshair.HandOpen
		update_crosshair()
	# raycast hit something and was hitting something
	# (edge case: where the player goes from one item to the next)
	# TODO: how to handle this same signal as started?
	if ray_cast.is_colliding() and was_colliding:
		if last_collider != ray_cast.get_collider():
			last_collider = ray_cast.get_collider()
			curr_state = GlobalEnums.Crosshair.HandOpen
			update_crosshair()
	# raycast stopped hitting something and was hitting something
	elif not ray_cast.is_colliding() and was_colliding:
		curr_state = GlobalEnums.Crosshair.Dot
		update_crosshair()
	was_colliding = ray_cast.is_colliding()

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
