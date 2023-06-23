extends Control

var data
@onready var score_labels = $VBoxContainer/Scores.get_children()
@onready var player_rank = $VBoxContainer/HBoxContainer3/VBoxContainer3/PlayerRank
@onready var player_high_score = $VBoxContainer/HBoxContainer3/VBoxContainer2/PlayerScore

func _ready():
	Leaderboard.leaderboard_updated.connect(update_leaderboard)
	Leaderboard.personal_score_updated.connect(update_personal)
	Leaderboard._get_leaderboards()
	update_personal({"rank" : Leaderboard.current_rank, "score": Leaderboard.current_high_score})


func _on_back_to_menu_pressed():
	get_tree().change_scene_to_file("res://Screens/MainMenuScreen.tscn")

func update_personal(score) -> void:
	player_rank.text = str(score.rank)
	player_high_score.text = str(score.score)

func update_leaderboard(board) -> void:
	data = board
	var i = 0
	while i < data.size():
		score_labels[i].set_data(data[i])
		i += 1
	while i < 10:
		score_labels[i].clear_data()
		i += 1


func _on_button_pressed():
	Leaderboard._get_leaderboards()
