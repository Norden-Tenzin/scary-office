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
var world_state: WorldState
var enemy_state: State
var current_action: Action

func _init() -> void:
	var patrolling: Action = preload("res://scenes/boss/actions/patrolling.gd").new(self)
	var searching: Action = preload("res://scenes/boss/actions/searching.gd").new(self)
	var attacking: Action = preload("res://scenes/boss/actions/attacking.gd").new(self)
	var chasing: Action = preload("res://scenes/boss/actions/chasing.gd").new(self)
	
	
#TODO get enemy state and determine action to take
	
func _physics_process(delta: float) -> void:
	#TODO get enemy state and determine action to take
	#current_action = something()
	
	#current_action.perform(delta)
	pass
	
