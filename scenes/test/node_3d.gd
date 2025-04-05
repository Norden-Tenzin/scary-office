extends Node3D

signal DragStarted(what: String)
signal Click(what: String)
signal LetGo(what: String)

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
	
	
func handle_click_and_drag(what: String, delta: float) -> void:
	var index: int = action_index[what]
	if Input.is_action_pressed(what):
		time[index] += delta
		if time[index] >= HOLD_TIME && !dragging[index]:
			dragging[index] = true
			DragStarted.emit(what)
	if Input.is_action_just_released(what):
		if time[index] < HOLD_TIME:
			Click.emit(what)
		if dragging[index]:
			LetGo.emit(what)
			dragging[index] = false
		time[index] = 0
		
		
func handle_all(delta: float) -> void:
	handle_click_and_drag("left_click", delta)
	handle_click_and_drag("right_click", delta)


func _physics_process(delta: float) -> void:
	handle_all(delta)
