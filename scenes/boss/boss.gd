extends CharacterBody3D

enum State
{
	Patrolling,
	Chasing,
	Alerted,
	Attacking,
	Searching
}

@onready var sc1: ShapeCast3D = $ShapeCast3D
@onready var na: NavigationAgent3D = $NavigationAgent3D
var gravity: int = 10
var speed: float = 3.0
var world_state: WorldState
var enemy_state: State
var current_action: Action
var actions: Dictionary

func _init() -> void:
	var patrolling: Action = preload("res://scenes/boss/actions/patrolling.gd").new(self)
	var searching: Action = preload("res://scenes/boss/actions/searching.gd").new(self)
	var attacking: Action = preload("res://scenes/boss/actions/attacking.gd").new(self)
	var chasing: Action = preload("res://scenes/boss/actions/chasing.gd").new(self)
	actions["patrolling"] = patrolling
	actions["searching"] = searching
	actions["attacking"] = attacking
	actions["chasing"] = chasing
	
	
#TODO get enemy state and determine action to take
func get_action_to_do() -> Action:
	return actions["chasing"]
	
func _physics_process(delta: float) -> void:
	#return
	#TODO get enemy state and determine action to take
	var new_action: Action = get_action_to_do()
	if !current_action || new_action != current_action && current_action.interrupt():
		current_action = new_action
	current_action.perform(delta)
	pass
	
