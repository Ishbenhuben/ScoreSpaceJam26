extends Control


func _ready():
	ready_round()
	randomize()
	
	$Background.material.set("shader_parameter/frequency", randf_range(6,8))
	$Background.material.set("shader_parameter/amplitude", 0.3)

func ready_round() -> void:
	for node in get_children():
		if not node is Sprite2D:
			node.ready_round()

func start_round() -> void:
	for node in get_children():
		if not node is Sprite2D:
			node.start_round()
