extends Node2D

const GROW_TIMER = 1.5
const MAX_SCALE = Vector2.ONE 

var current_growth = 0

var flower_id : int


@onready var backgrounds = [$BG1, $BG2]

func _ready():
	randomize()
	$GrowthTimer.wait_time = GROW_TIMER
	set_bg_shaders_param("background_color", Color('FEFCEF'))
	set_bg_shaders_param("rand", Vector3(randf_range(0,1000), randf_range(0,1000), randf_range(0,50000)))
	
func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
	set_flower_backgrounds(flower_id)
	start_growth()

func cut_flower(next_flower_id:int) -> void:
	if $GrowthTimer.time_left == 0:
		Events.emit_signal("flower_cut", flower_id)
		set_shader_circle_size(0.0)
		set_flower_id(next_flower_id)
	

func start_growth() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	$FlowerSprite.scale = Vector2.ONE * 0.0
	tween.tween_property($FlowerSprite, "scale", Vector2.ONE * MAX_SCALE, GROW_TIMER)
	
	
	var tween2 = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween2.parallel().tween_method(set_shader_circle_size, 0.0, 0.5, GROW_TIMER)
	$GrowthTimer.start()

func set_shader_circle_size(value: float):
	set_bg_shaders_param("circle_size", value)
	

func set_bg_shaders_param(param : String, value) -> void:
	for bg in backgrounds:
		bg.material.set("shader_parameter/" + param, value)

func set_flower_backgrounds(id : int) -> void:
	var i = 0
	for bg in backgrounds:
		bg.visible = false
	for texture in GameData.BG_FLOWER_TEXTURES[id]:
		backgrounds[i].visible = true
		backgrounds[i].set_texture(texture)
		backgrounds[i].material.set("shader_parameter/paint_color", GameData.FLOWER_COLORS[id][i])
		i += 1
		
