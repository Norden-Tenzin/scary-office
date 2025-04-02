extends Node
class_name SceneManager

@export var world3d: Node3D
@export var gui: Control
@export var transition_manager: TransitionManager

var curr_3d_scene: Node3D
var curr_gui_scene: Control

var curr_3d_scene_name: GlobalEnums.SceneName
var curr_gui_scene_name: GlobalEnums.SceneName

# UI
const splash_screen_manager: String = "res://scenes/splash_screen_manager/splash_screen_manager.tscn"
const main_menu: String = "res://scenes/ui/main_menu.tscn"
const pause_menu: String = "res://scenes/ui/pause_menu.tscn"
const settings_menu: String = "res://scenes/ui/settings_menu.tscn"
const end_screen: String = "res://scenes/ui/end_screen.tscn"

func _ready() -> void:
	Global.scene_manager = self
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	self.change_gui_scene(
		GlobalEnums.SceneName.SplashScreenManager,
		true,
		false,
		false,
	)
	#curr_gui_scene = $GUI/SplashScreenManager

# a pause menu
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		# checks if the world3d has children aka gamein in play
		if world3d.get_children().size() > 0:
			var children: Array[Node] = gui.get_children()
			if children.size() > 0:
				get_tree().paused = !get_tree().paused
				for child in children:
					child.queue_free()
			else:
				get_tree().paused = !get_tree().paused
				Global.scene_manager.change_gui_scene(
					GlobalEnums.SceneName.PauseMenu,
					true,
					false,
					false
				)
		if !get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("reset"):
		if world3d.get_children().size() > 0:
			var children: Array[Node] = gui.get_children()
			if children.size() > 0:
				pass
			else:
				reset_3d_scene()

func get_scene(scene_name: GlobalEnums.SceneName) -> Node:
	match scene_name:
		GlobalEnums.SceneName.SplashScreenManager:
			return load(splash_screen_manager).instantiate()
		GlobalEnums.SceneName.MainMenu:
			return load(main_menu).instantiate()
		GlobalEnums.SceneName.PauseMenu:
			return load(pause_menu).instantiate()
		GlobalEnums.SceneName.SettingsMenu:
			return load(settings_menu).instantiate()
		GlobalEnums.SceneName.EndScreen:
			return load(end_screen).instantiate()
		_ :
			return load(main_menu).instantiate()

func reset_3d_scene(
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
) -> void:
	if transition:
		transition_manager.transition(transition_out, seconds)
		await transition_manager.animation_player.animation_finished
	if curr_3d_scene != null:
		if delete: 
			curr_3d_scene.queue_free()
		elif keep_running:
			curr_3d_scene.visible = false
		else:
			gui.remove_child(curr_3d_scene)
	var new_scene_obj: Node3D = get_scene(curr_3d_scene_name)
	world3d.add_child(new_scene_obj)
	curr_3d_scene = new_scene_obj
	if transition:
		transition_manager.transition(transition_in, seconds)
	# Reset gui and un pause the game
	var children: Array[Node] = gui.get_children()
	if children.size() > 0:
		get_tree().paused = !get_tree().paused
		for child in children:
			child.queue_free()
	

func change_3d_scene(
	scene_name: GlobalEnums.SceneName,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
) -> void:
	curr_3d_scene_name = scene_name
	if transition:
		transition_manager.transition(transition_out, seconds)
		await transition_manager.animation_player.animation_finished
	if curr_3d_scene != null:
		if delete: 
			curr_3d_scene.queue_free()
		elif keep_running:
			curr_3d_scene.visible = false
		else:
			gui.remove_child(curr_3d_scene)
	var new_scene_obj: Node3D = get_scene(scene_name)
	world3d.add_child(new_scene_obj)
	curr_3d_scene = new_scene_obj
	if transition:
		transition_manager.transition(transition_in, seconds)

func change_gui_scene(
	scene_name: GlobalEnums.SceneName,
	delete: bool = true,
	keep_running: bool = false,
	transition: bool = true,
	transition_in: String = "fade_in",
	transition_out: String = "fade_out",
	seconds: float = 1.0
) -> void:
	curr_gui_scene_name = scene_name
	if transition:
		transition_manager.transition(transition_out, seconds)
		await transition_manager.animation_player.animation_finished
	if curr_gui_scene != null:
		if delete: 
			curr_gui_scene.queue_free()
		elif keep_running:
			curr_gui_scene.visible = false
		else:
			gui.remove_child(curr_gui_scene)
	var new_scene_obj: Control = get_scene(scene_name)
	gui.add_child(new_scene_obj)
	curr_gui_scene = new_scene_obj
	if transition:
		transition_manager.transition(transition_in, seconds)
