extends MarginContainer


@onready var player_name = $ResultsVbox/PlayerName
@onready var submit

func _ready():
	player_name.text = Leaderboard.player_name
	$ResultsVbox/Submit.disabled = (len(player_name.text) <= 0)


func _on_submit_pressed():
	Leaderboard._upload_score($ResultsVbox/ScoreValue.text)
	Leaderboard._change_player_name(player_name.text)


func _on_player_name_text_changed(new_text):
	$ResultsVbox/Submit.disabled = (len(new_text) <= 0)
