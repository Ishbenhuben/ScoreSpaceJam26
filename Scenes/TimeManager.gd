extends Control

var countdown = 3

var initial_time = 10
var additional_time = 2.0
var time_left = 0
var total_time = 0

var additional_time_displayed_duration = 1.5

var combo_multiplier = 1.08

var results = {}

func _ready() -> void:
	set_physics_process(false)
	Events.connect("bouquet_made", bouquet_made)
	$Added_Time/added_time_timer.set_wait_time(additional_time_displayed_duration)

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
	add_new_results("Time Played", Utils.seconds_to_string(total_time))
	Events.emit_signal("round_ended")

func add_new_results(property:String, value:Variant) -> void:
	results[property] = value





