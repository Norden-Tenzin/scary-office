class_name Action

enum ActionState
{
	IDLE,
	EXECUTING,
	FAILED,
	SUCCEEDED,
}

var actor: CharacterBody3D
var action_state: ActionState = ActionState.IDLE

func _init(actor: CharacterBody3D) -> void:
	self.actor = actor

func perform(delta: float) -> void:
	pass
