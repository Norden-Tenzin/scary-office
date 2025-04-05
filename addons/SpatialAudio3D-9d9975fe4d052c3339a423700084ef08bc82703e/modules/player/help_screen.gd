extends CenterContainer


func _ready():
	var config = ConfigFile.new()
	config.load("user://settings.ini")
	var show_help = config.get_value("global", "show_help", true)
	visible = show_help

	config.set_value("global", "show_help", false)
	config.save("user://settings.ini")


func _input(_event):
	if Input.is_action_just_pressed("help"):
		visible = not visible
