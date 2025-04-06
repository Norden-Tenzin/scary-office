extends Node3D

@export var player: Player
@export var head: Node3D
@export var hands: Node3D

@export_category("Player Stat")
@export var SPEED: float = 5.0
@export var SPEED_CROUCHED: float = 2.5
var move_speed: float = 0.0

@export_category("Head Bob")
var head_base_pos: Vector3 = Vector3.ZERO
@export var BOB_FREQ: float = 2.0
@export var BOB_AMP: float = 0.008
@export var bob_time: float = 0.0

func _ready() -> void:
	head_base_pos = head.position
	move_speed = SPEED

func _physics_process(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * move_speed
		player.velocity.z = direction.z * move_speed
	else:
		player.velocity.x = 0.0
		player.velocity.z = 0.0

	bob_time += delta * player.velocity.length() * float(player.is_on_floor())
	head.transform.origin = _headbob(bob_time)
	hands.transform.origin = head.transform.origin
	player.move_and_slide()

func _headbob(time: float) -> Vector3:
	var pos := head_base_pos
	pos.y = head_base_pos.y + sin(time * BOB_FREQ) * BOB_AMP
	pos.x = head_base_pos.x + cos(time * BOB_FREQ) * BOB_AMP
	return pos

func _on_player_on_crouch(is_crouched: bool) -> void:
	if is_crouched:
		move_speed = SPEED_CROUCHED
		head_base_pos.y = 0.8
	else:
		move_speed = SPEED
		head_base_pos.y = 1.6
