extends Control

func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Screens/MainMenuScreen.tscn")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Screens/GameScreen.tscn")

func _ready() -> void:
	$GridManager.start_round()
	$CollectedFlowerManager.start_round()
