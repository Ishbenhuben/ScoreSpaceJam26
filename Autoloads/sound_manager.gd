extends Node2D

@onready var fx_player = $SFX
@onready var music_player = $Music

var sounds: Dictionary = {
	"slash" : [preload("res://Assets/sounds/katana/k1.mp3"), preload("res://Assets/sounds/katana/k2.mp3"), preload("res://Assets/sounds/katana/k3.mp3")]
}


func _ready():
	randomize()
	#music_player.play(17)

func play_fx(sound : String, index : int = -1) -> void:
	if index == -1:
		index = randi() % len(sounds[sound])
	fx_player.stream = sounds[sound][index]
	fx_player.play()


func _on_music_finished():
	music_player.play()
