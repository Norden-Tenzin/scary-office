extends Control

# Menu
func _on_resume_button_pressed() -> void:
	get_tree().paused = !get_tree().paused
	self.queue_free()

func _on_settings_button_pressed() -> void:
	Global.scene_manager.change_gui_scene(
		GlobalEnums.SceneName.SettingsPauseMenu,
		true,
		false,
		false
	)

func _on_reload_button_pressed() -> void:
	Global.scene_manager.reset_3d_scene()
	#Global.scene_manager.change_3d_scene(
		#"res://scenes/ui/.tscn",
	#)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
