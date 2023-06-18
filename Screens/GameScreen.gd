extends Control


func _ready():
	start_round()

func start_round() -> void:
	for node in get_children():
		node.start_round()
