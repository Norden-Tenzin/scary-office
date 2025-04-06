extends Node

signal DragStarted(action: GlobalEnums.ActionInput)
signal Click(action: GlobalEnums.ActionInput)
signal LetGo(action: GlobalEnums.ActionInput)
signal drop(action: GlobalEnums.ActionInput)
signal crouch

const HOLD_TIME = 0.15
var time: Array
var dragging: Array
var action_index: Dictionary

func _ready() -> void:
	var input_actions: Array = InputMap.get_actions()
	var value: int = 0
	for index: String in input_actions:
		action_index[index] = value
		value += 1
	time.resize(input_actions.size())
	time.fill(0)
	dragging.resize(input_actions.size())
	dragging.fill(false)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("drop_left"):
		drop.emit(GlobalEnums.ActionInput.DropLeft)
	if Input.is_action_just_pressed("drop_right"):
		drop.emit(GlobalEnums.ActionInput.DropRight)
	if Input.is_action_just_pressed("crouch"):
		crouch.emit()

func handle_click_and_drag(action: GlobalEnums.ActionInput, delta: float) -> void:
	match action:
		GlobalEnums.ActionInput.LeftClick:
			handle_action(action, "left_click", delta)
		GlobalEnums.ActionInput.RightClick:
			handle_action(action, "right_click", delta)

func handle_action(action: GlobalEnums.ActionInput, action_string: String, delta: float) -> void:
	var index: int = action_index[action_string]
	if Input.is_action_pressed(action_string):
		time[index] += delta
		if time[index] >= HOLD_TIME && !dragging[index]:
			dragging[index] = true
			DragStarted.emit(action)
	if Input.is_action_just_released(action_string):
		if time[index] < HOLD_TIME:
			Click.emit(action)
		if dragging[index]:
			LetGo.emit(action)
			dragging[index] = false
		time[index] = 0

func handle_all(delta: float) -> void:
	handle_click_and_drag(GlobalEnums.ActionInput.LeftClick, delta)
	handle_click_and_drag(GlobalEnums.ActionInput.RightClick, delta)

func _physics_process(delta: float) -> void:
	handle_all(delta)
