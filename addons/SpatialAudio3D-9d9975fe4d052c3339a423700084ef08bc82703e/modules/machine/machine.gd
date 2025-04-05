extends Node3D
class_name Machine

## This is a machine.
## A machine has one or more switches,
## who turn on/off one or more motors.
## Title and activation/deactivation text are displayed when hovering over a switch.

@export var title: String
@export var activate_text: String
@export var deactivate_text: String
@export_node_path var switches: Array[NodePath]
@export_node_path var motors: Array[NodePath]
var running := false
var action_text: String:
	get():
		return "%s [%s]" % [title, activate_text if not running else deactivate_text]


func _ready():
	# stop autoplaying animations
	# (you need to set the animation you want to play as default to autoplay)
	for node_path in motors:
		var motor = get_node(node_path)
		match motor.get_class():
			"AnimationPlayer":
				var m: AnimationPlayer = motor
				m.stop()


func toggle():
	for node_path in motors:
		var motor = get_node(node_path)
		match motor.get_class():
			"AudioStreamPlayer3D":
				var m: SpatialAudio3D = motor
				if not running:
					m.do_play()
				else:
					m.do_stop()
			"AnimationPlayer":
				var m: AnimationPlayer = motor
				if not running:
					m.play()
				else:
					m.stop()

	running = not running

	for node_path in switches:
		var switch = get_node(node_path)
		var s: MeshInstance3D = switch.find_child("Indicator")
		@warning_ignore("unsafe_property_access")
		s.mesh.material.emission_enabled = running


func validate_switch(node: Node):
	for node_path in switches:
		var switch = get_node(node_path)
		if node == switch:
			return true

	return false
