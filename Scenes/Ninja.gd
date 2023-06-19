extends Node2D

@onready var anim_player = $AnimationPlayer

const MAX_SPEED = 2000

var tween

func _ready():
	anim_player.play("idle")
	Events.ninja_moved_to.connect(move_to)
	Events.ninja_teleported_to.connect(teleport_to)
	Events.connect("round_ended", end_round)

func ready_round() -> void:
	show()
	
func start_round() -> void:
	pass

func end_round() -> void:
	pass
	#hide()

func move_to(new_pos : Vector2) -> void:
	var curr_pos = global_position
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position", new_pos, (curr_pos - new_pos).length()/MAX_SPEED)
	tween.tween_callback(finished_move)
	
func finished_move() -> void:
	tween = null
	Events.emit_signal("ninja_finished_moving")
	
func teleport_to(new_pos : Vector2) -> void:
	global_position = new_pos
	
