extends Control

var countdown = 3

var initial_time = 10
var additional_time = 2.0
var time_left = 0
var total_time = 0

var additional_time_displayed_duration = 1.5

var combo_multiplier = 1.08

@onready var score_label = $ResultsPanel/ResultsVbox/ScoreValue
@onready var bouquets_label = $ResultsPanel/ResultsVbox/Bouquets/Bouquets_value
@onready var max_combo_label = $ResultsPanel/ResultsVbox/Max_Combo/max_combo_value
@onready var time_played_label = $ResultsPanel/ResultsVbox/Time_Played/Time_Played_value

var results = {}
var labels_dict = {}

func _ready() -> void:
	set_physics_process(false)
	Events.connect("bouquet_made", bouquet_made)
	Events.connect("add_new_result", add_new_results)
	$Added_Time/added_time_timer.set_wait_time(additional_time_displayed_duration)
	labels_dict = {"score" : score_label,
					"bouquets" : bouquets_label,
					"max_combo" : max_combo_label,
					"time_played" : time_played_label,}

func _physics_process(delta) -> void:
	time_left -= delta
	$Timer/Time_Left.set_text("%.1f" % time_left)
	if time_left <= 0:
		set_physics_process(false)
		end_round()

func ready_round() -> void:
	countdown = 3
	$Countdown/Countdown_Label.set_text(str(countdown))
	$Countdown.show()
	$Countdown/Countdown_Timer.start()

func _on_countdown_timer_timeout():
	countdown -= 1
	if countdown > 0:
		$Countdown/Countdown_Label.set_text(str(countdown))
		$Countdown/Countdown_Timer.start()
	else:
		get_parent().start_round()
		$Countdown.hide()

func start_round() -> void:
	time_left = initial_time
	total_time = initial_time
	set_physics_process(true)

func bouquet_made(combo_count:int) -> void:
	add_time(additional_time * pow(combo_multiplier,combo_count-1))

func add_time(addtnl_time:float) -> void:
	print("added time: ", addtnl_time)
	time_left += addtnl_time
	total_time += addtnl_time
	show_addtnl_time(addtnl_time)

func show_addtnl_time(addtnl_time:float) -> void:
	$Added_Time/Added_Time_Label.set_text("+%.3f" % addtnl_time)
	$Added_Time.show()
	$Added_Time/added_time_timer.start()

func _on_added_time_timer_timeout():
	$Added_Time.hide()

func end_round() -> void:
	print("Total Time: ", Utils.seconds_to_string(total_time))
	add_new_results("time_played", Utils.seconds_to_string(total_time))
	Events.emit_signal("round_ended")
	show_results()

func add_new_results(property:String, value:String) -> void:
	results[property] = value

func show_results() -> void:
	for property in labels_dict:
		if property in results:
			labels_dict[property].set_text(results[property])
		else:
			print(property)
			labels_dict[property].set_text("-1")
	var tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_method($ResultsPanel.set_position, Vector2(0,1920), Vector2(0,0), 1)
