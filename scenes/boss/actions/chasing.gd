extends Action

var timer: Timer = Timer.new()
var direction: Vector3 = Vector3.ZERO

func _init(actor: CharacterBody3D) -> void:
	super(actor)
	timer.wait_time = 0.150
	timer.autostart = false
	timer.timeout.connect(_on_timer_chase)
	actor.add_child(timer)


func _on_timer_chase() -> void:
	direction = Vector3()
	actor.na.target_position = Global.player.global_position
	direction = actor.na.get_next_path_position() - actor.global_position
	direction = direction.normalized()


func perform(delta: float) -> void:
	if timer.is_stopped():
		timer.start()
	actor.velocity = direction * actor.speed
	if !actor.is_on_floor():
		actor.velocity.y -= actor.gravity
	actor.move_and_slide()

func interrupt() -> bool:
	return true
