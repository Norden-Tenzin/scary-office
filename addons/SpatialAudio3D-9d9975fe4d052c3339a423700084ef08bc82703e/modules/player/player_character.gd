extends CharacterBody3D

@onready var camera: Node3D = %Camera
@onready var InteractionRaycast: RayCast3D = $Camera/InteractionRaycast
@onready var ActionText: Label = $CenterContainer/ActionText
@onready var InteractionPoint: ColorRect = $Camera/InteractionPoint
@onready var Gunshot: SpatialAudio3D = $Gunshot
@onready var Rifleshot: SpatialAudio3D = $Rifleshot
@onready var Sinewave: SpatialAudio3D = $Sinewave
@onready var Sawtooth: SpatialAudio3D = $Sawtooth
@onready var Whitenoise: SpatialAudio3D = $Whitenoise
@onready var Soundcapsule = preload("res://modules/soundcapsule/soundcapsule.tscn")
@onready var Footsteps: SpatialAudio3D = $"Footsteps concrete"
@onready var Drumset: SpatialAudio3D = $Drumset
@onready var Speechtest: SpatialAudio3D = $Speechtest
@export var main_camera: Camera3D

enum weapon { gun, rifle, sinewave, sawtooth, whitenoise, soundcapsule }
var selected_weapon = weapon.gun
var footsteps_enabled = false
var drumset_enabled = false
var speechtest_enabled = false
var soundcapsule: Node3D
var soundcapsule_speed: int = 10

var _speed: float
var camera_rotation: Vector2 = Vector2(0.0,0.0)
var mouse_sensitivity = 0.001
var crouched: bool = false
var crouch_blocked: bool = false

const NORMAL_speed = 4.0
@export_range(1.0,10.0) var sprint_speed: float = 20.0
@export_range(0.1,1.0) var walk_speed: float = 0.5
var turbo_speed: float = 100.0
var speed_modifier: float = NORMAL_speed

var is_falling: bool = false
var fall_start: float
var fall_time: float

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed: float
var stepped: float = 0
var steptime: int = 0
var guimode: float = false

func _ready() -> void:
	update_camera_rotation()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	calculate_movement_parameters()
	update_weapons_bar()

func update_camera_rotation() -> void:
	var current_rotation = get_rotation()
	camera_rotation.x = current_rotation.y
	camera_rotation.y = current_rotation.x

func _input(event: InputEvent) -> void:

	# capture/uncapture mouse
	if event is InputEventMouseButton:
		@warning_ignore("unsafe_property_access")
		if event.pressed and event.button_index == 2:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		@warning_ignore("unsafe_property_access")
		if event.pressed and event.button_index == 1:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	## zoom on rightclick
	#if Input.is_action_pressed("zoom"):
		#var blend_tween = get_tree().create_tween()
		#blend_tween.tween_property(%Camera/MainCamera, "fov", 30.0, 0.15)
	#else:
		#var blend_tween = get_tree().create_tween()
		#blend_tween.tween_property(%Camera/MainCamera, "fov", 75.0, 0.15)

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var ev: InputEventMouseMotion = event
		var MouseEvent = ev.relative * mouse_sensitivity
		if not guimode:
			camera_look(MouseEvent)

	speed_modifier = NORMAL_speed
	if Input.is_action_pressed("sprint"):
		speed_modifier = sprint_speed
	if Input.is_action_pressed("turbo"):
		speed_modifier = turbo_speed

func calculate_movement_parameters() -> void:
	speed = speed_modifier
	_speed = speed

func camera_look(Movement: Vector2) -> void:
	camera_rotation += Movement

	transform.basis = Basis()
	camera.transform.basis = Basis()

	rotate_object_local(Vector3(0,1,0),-camera_rotation.x) # first rotate in Y
	camera.rotate_object_local(Vector3(1,0,0), -camera_rotation.y) # then rotate in X
	#camera_rotation.y = clamp(camera_rotation.y,-1.5,1.2)

func use_action() -> bool:
	if InteractionRaycast.is_colliding():
		var collider: Node = InteractionRaycast.get_collider()
		var machine: Machine = get_machine(collider)
		if machine and machine.validate_switch(collider):
			ActionText.text = machine.action_text
			ActionText.visible = true
			InteractionPoint.color = Color("fff")
			if Input.is_action_just_pressed("fire"):
				machine.toggle()
				return true
			return false
		else:
			ActionText.visible = false
			InteractionPoint.color = Color("ffffff64")
			return false
	else:
		ActionText.visible = false
		InteractionPoint.color = Color("ffffff64")
		return false

func get_machine(node: Node):
	if node is Machine:
		return node
	else:
		var p = node.get_parent()
		if p:
			return get_machine(p)

func update_weapons_bar():
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Gun.label_settings.font_color = "ff0" if selected_weapon == weapon.gun else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Rifle.label_settings.font_color = "ff0" if selected_weapon == weapon.rifle else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Sinewave.label_settings.font_color = "ff0" if selected_weapon == weapon.sinewave else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Sawtooth.label_settings.font_color = "ff0" if selected_weapon == weapon.sawtooth else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Whitenoise.label_settings.font_color = "ff0" if selected_weapon == weapon.whitenoise else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Soundcapsule.label_settings.font_color = "ff0" if selected_weapon == weapon.soundcapsule else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Soundcapsule/ProgressBar.visible = selected_weapon == weapon.soundcapsule
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Soundcapsule/ProgressBar.value = soundcapsule_speed
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Footsteps.label_settings.font_color = "0f0" if footsteps_enabled else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Drumset.label_settings.font_color = "0f0" if drumset_enabled else "fff"
	@warning_ignore("unsafe_property_access")
	$WeaponsBar/Speechtest.label_settings.font_color = "0f0" if speechtest_enabled else "fff"

func weapons_action():
	if Input.is_action_just_pressed("select_gun"):
		selected_weapon = weapon.gun
		update_weapons_bar()
	if Input.is_action_just_pressed("select_rifle"):
		selected_weapon = weapon.rifle
		update_weapons_bar()
	if Input.is_action_just_pressed("select_sinewave"):
		selected_weapon = weapon.sinewave
		update_weapons_bar()
	if Input.is_action_just_pressed("select_sawtooth"):
		selected_weapon = weapon.sawtooth
		update_weapons_bar()
	if Input.is_action_just_pressed("select_whitenoise"):
		selected_weapon = weapon.whitenoise
		update_weapons_bar()
	if Input.is_action_just_pressed("select_soundcapsule"):
		selected_weapon = weapon.soundcapsule
		update_weapons_bar()
	if Input.is_action_just_pressed("toggle_footsteps"):
		footsteps_enabled = not footsteps_enabled
		update_weapons_bar()
	if Input.is_action_just_pressed("toggle_drumset"):
		@warning_ignore("standalone_ternary")
		Drumset.do_stop() if drumset_enabled else Drumset.do_play()
		drumset_enabled = not drumset_enabled
		Drumset.visible = drumset_enabled
		update_weapons_bar()
	if Input.is_action_just_pressed("toggle_speechtest"):
		@warning_ignore("standalone_ternary")
		Speechtest.do_stop() if speechtest_enabled else Speechtest.do_play()
		speechtest_enabled = not speechtest_enabled
		update_weapons_bar()

	if selected_weapon == weapon.soundcapsule:
		if Input.is_action_just_pressed("soundcapsule_more"):
			soundcapsule_speed += 10
			soundcapsule_speed = clamp(soundcapsule_speed, 10, 100)
			update_weapons_bar()
		if Input.is_action_just_pressed("soundcapsule_less"):
			soundcapsule_speed -= 10
			soundcapsule_speed = clamp(soundcapsule_speed, 10, 100)
			update_weapons_bar()

	if Input.is_action_just_pressed("fire"):
		match selected_weapon:
			weapon.gun:
				Gunshot.do_play()
			weapon.rifle:
				Rifleshot.do_play()
			weapon.sinewave:
				Sinewave.do_play()
			weapon.sawtooth:
				Sawtooth.do_play()
			weapon.whitenoise:
				Whitenoise.do_play()
			weapon.soundcapsule:
				if soundcapsule:
					soundcapsule.queue_free()
					soundcapsule = null
				soundcapsule = Soundcapsule.instantiate()
				get_tree().get_root().add_child(soundcapsule)
				soundcapsule.global_position = global_position + (global_transform.basis * Vector3(0, 0, -3))
				var rb: RigidBody3D = soundcapsule.get_child(0)
				rb.angular_velocity = Vector3(randi_range(-3, 3), randi_range(-3, 3), randi_range(-3, 3))
				@warning_ignore("unsafe_property_access")
				rb.set_global_transform(%MainCamera.global_transform)
				rb.apply_impulse(rb.global_transform.basis.z * (soundcapsule_speed * -1) + rb.global_transform.basis.y * (soundcapsule_speed / 100.0 * 14 * -1))

	if Input.is_action_just_released("fire"):
		match selected_weapon:
			weapon.sinewave:
				Sinewave.do_stop()
			weapon.sawtooth:
				Sawtooth.do_stop()
			weapon.whitenoise:
				Whitenoise.do_stop()

func _physics_process(_delta: float) -> void:
	if not use_action():
		weapons_action()

	# Add the gravity.
	velocity.y -= 9.0 * _delta
	velocity.y = clamp(velocity.y, -50, 0)

	# jump
	if Input.is_action_pressed("jump"):
		velocity.y = 10

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	calculate_movement_parameters()

	velocity.x = move_toward(velocity.x, direction.x * _speed, speed)
	velocity.z = move_toward(velocity.z, direction.z * _speed, speed)

	# footsteps
	stepped += _delta * Vector2(velocity.x, velocity.z).length()
	if footsteps_enabled and stepped >= 2 and abs(Time.get_ticks_msec() - steptime) > 300:
		Footsteps.do_play()
		stepped = 0
		steptime = Time.get_ticks_msec()

	move_and_slide()
