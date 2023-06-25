extends Control

@onready var sample_flowers = $MarginContainer/VBoxContainer/Drawing/FlowerContainer

func _ready():
	set_flowers(PlayerData.drawing_animation)
	sample_flowers.set_pressed(PlayerData.drawing_animation)

func _on_back_to_menu_pressed():
	print("clicked")
	get_tree().change_scene_to_file("res://Screens/MainMenuScreen.tscn")

func _on_music_slider_value_changed(value):
	SoundManager.music_player.volume_db = value

func _on_sound_slider_value_changed(value):
	SoundManager.fx_player.volume_db = value

func set_flowers(pressed:bool) -> void:
	for i in range(len(sample_flowers.get_children())):
		sample_flowers.get_child(i).set_flower_id(i,pressed)
		
func _on_flower_container_toggled(button_pressed):
	set_flowers(button_pressed)
	PlayerData.drawing_animation = button_pressed
