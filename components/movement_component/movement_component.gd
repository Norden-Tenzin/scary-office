extends Node3D

@export var player: CharacterBody3D
@export var head: Node3D

@export_category("Player Stat")
@export var SPEED: float = 5.0

@export_category("Head Bob")
var head_base_pos: Vector3 = Vector3.ZERO
@export var BOB_FREQ: float = 2.0
@export var BOB_AMP: float = 0.08
@export var bob_time: float = 0.0

func _ready() -> void:
	head_base_pos = head.position
	print(head_base_pos)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		player.velocity.x = direction.x * SPEED
		player.velocity.z = direction.z * SPEED
	else:
		player.velocity.x = 0.0
		player.velocity.z = 0.0
	
	# Head Bob
	bob_time += delta * player.velocity.length() * float(player.is_on_floor())
	head.transform.origin = _headbob(bob_time)
	print(head.transform.origin)
	
	player.move_and_slide()

func _headbob(time: float) -> Vector3:
	var pos := head_base_pos
	pos.y = head_base_pos.y + sin(time * BOB_FREQ) * BOB_AMP
	pos.x = head_base_pos.x + cos(time * BOB_FREQ) * BOB_AMP
	return pos
