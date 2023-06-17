extends Node2D

@onready var anim_player = $AnimationPlayer

const MAX_SPEED = 750

func _ready():
	anim_player.play("idle")
	Events.ninja_moved_to.connect(move_to)
	Events.ninja_teleported_to.connect(teleport_to)

func move_to(new_pos : Vector2) -> void:
	print("hello")
	var curr_pos = global_position
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", new_pos, (curr_pos - new_pos).length()/MAX_SPEED)

func teleport_to(new_pos : Vector2) -> void:
	global_position = new_pos
	