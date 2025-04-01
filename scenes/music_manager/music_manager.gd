extends Node
class_name MusicManager

# How to add more audio tracks
# 1. add a preaload var in this file
# 2. create a enum for that file in GlobalEnum.AudioName
# 3. handle that enum in play 

# Example
#var normal_music: AudioStream = preload("res://assets/audio/music/normal.mp3")

@export var music_player: AudioStreamPlayer
var curr_audio: GlobalEnums.MusicName

func _ready() -> void:
	Global.music_manager = self

func play(new_music: GlobalEnums.MusicName) -> void:
	pass
	#if curr_audio != new_music:
		#match new_music:
			#GlobalEnums.MusicName.Normal : 
				#curr_audio = GlobalEnums.MusicName.Normal
				#self.play_audio(music_player, normal_music)

func play_audio(audio_player: AudioStreamPlayer, audio: AudioStream) -> void:
	audio_player.stream = audio
	audio_player.play()

func stop() -> void:
	curr_audio = GlobalEnums.MusicName.None
	music_player.stop()
