extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Screens/GameScreen.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Screens/TutorialScreen.tscn")

func _on_leaderboards_pressed():
	get_tree().change_scene_to_file("res://Screens/LeaderboardsScreen.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Screens/SettingsScreen.tscn")
