extends Control


func _ready():
	pass # Replace with function body.

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Screens/MainMenuScreen.tscn")


func _on_music_slider_value_changed(value):
	SoundManager.music_player.volume_db = value


func _on_sound_slider_value_changed(value):
	SoundManager.fx_player.volume_db = value
