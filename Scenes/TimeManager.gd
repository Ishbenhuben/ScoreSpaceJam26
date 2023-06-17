extends Node2D

var initial_time = 10
var additional_time
var time_left
var total_time

func _physics_process(delta) -> void:
	time_left -= delta
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
