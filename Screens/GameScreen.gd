extends Control


func _ready():
	ready_round()

func ready_round() -> void:
	for node in get_children():
		node.ready_round()

func start_round() -> void:
	for node in get_children():
		node.start_round()
