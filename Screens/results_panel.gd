extends MarginContainer


@onready var player_name = $ResultsVbox/PlayerName
@onready var submit_btn = $ResultsVbox/Submission/Submit

@onready var score_label = $ResultsVbox/ScoreValue
@onready var bouquets_label = $ResultsVbox/Bouquets/Bouquets_value
@onready var max_combo_label = $ResultsVbox/Max_Combo/max_combo_value
@onready var time_played_label = $ResultsVbox/Time_Played/Time_Played_value

@onready var submit_container = $ResultsVbox/Submission
@onready var submitted_label = $ResultsVbox/Submitted

var results = {}
var labels_dict = {}

func _ready():
	player_name.text = Leaderboard.player_name
	submit_btn.disabled = (len(player_name.text) <= 0)
	labels_dict = {"score" : score_label,
					"bouquets" : bouquets_label,
					"max_combo" : max_combo_label,
					"time_played" : time_played_label,}
	Events.connect("add_new_result", add_new_results)
	submit_container.show()
	submitted_label.hide()
	

func _on_submit_pressed():
	Leaderboard._upload_score($ResultsVbox/ScoreValue.text)
	Leaderboard._change_player_name(player_name.text)
	Leaderboard._get_player_name()
	submit_container.hide()
	submitted_label.show()

func _on_player_name_text_changed(new_text):
	submit_btn.disabled = (len(new_text) <= 0)

func add_new_results(property:String, value:String) -> void:
	results[property] = value

func show_results() -> void:
	for property in labels_dict:
		if property in results:
			labels_dict[property].set_text(results[property])
		else:
			labels_dict[property].set_text("-1")
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_method(set_position, Vector2(0,1920), Vector2(0,0), 2)


func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://Screens/MainMenuScreen.tscn")


func _on_leader_boards_button_pressed():
	get_tree().change_scene_to_file("res://Screens/LeaderboardsScreen.tscn")


func _on_play_again_button_pressed():
	get_tree().change_scene_to_file("res://Screens/GameScreen.tscn")
