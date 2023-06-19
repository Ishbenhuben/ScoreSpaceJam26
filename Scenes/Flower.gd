extends Node2D

const GROW_TIMER = 1.5
const MAX_SCALE = Vector2.ONE * 0.5

var current_growth = 0

var flower_id : int

@onready var flower_material = $BackgroundColor.material

func _ready():
	randomize()
	$GrowthTimer.wait_time = GROW_TIMER
	
	flower_material.set("shader_parameter/background_color", Color.BLUE)
	flower_material.set("shader_parameter/rand", Vector3(randf_range(0,1000), randf_range(0,1000), randf_range(0,50000)))

	

func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
	flower_material.set("shader_parameter/background_color", GameData.FLOWER_COLORS[flower_id])
	start_growth()

func cut_flower(next_flower_id:int) -> void:
	if $GrowthTimer.time_left == 0:
		Events.emit_signal("flower_cut", flower_id)
		set_flower_id(next_flower_id)
	set_shader_circle_size(0.0)

func start_growth() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_method($FlowerSprite.set_scale, Vector2.ONE * 0.0, Vector2.ONE * MAX_SCALE, GROW_TIMER)
	tween.tween_method(set_shader_circle_size, 0.0, 0.5, GROW_TIMER)
	$GrowthTimer.start()

func set_shader_circle_size(value: float):
	flower_material.set("shader_parameter/circle_size", value)
