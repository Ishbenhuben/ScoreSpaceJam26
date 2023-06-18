extends Control

var initial_time = 1000
var additional_time
var time_left
var total_time

var combo_multiplier = 1.1

func _ready() -> void:
	pass

func _physics_process(delta) -> void:
	time_left -= delta
	$Timer/Time_Left.set_text("%.1f" % time_left)
	if time_left <= 0:
		set_physics_process(false)
		end_round()

func start_round() -> void:
	time_left = initial_time
	total_time = initial_time
	set_physics_process(true)

func add_time(addtnl_time:float) -> void:
	time_left += addtnl_time
	total_time += addtnl_time

func end_round() -> void:
	print("Total Time: ",str(total_time))
	Events.emit_signal("round_ended")
