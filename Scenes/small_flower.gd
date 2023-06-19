extends Node2D


const MAX_SPEED = 3000
const MIN_SCALE = Vector2(0.5, 0.5)
const TIME = 0.25

var current_growth = 0

var flower_id : int


@onready var backgrounds = [$BG1, $BG2]

var queued_for_clearing = false
var animation_locked = false

func _ready():
	randomize()
	set_bg_shaders_param("background_color", Color('FEFCEF'))
	set_bg_shaders_param("rand", Vector3(randf_range(0,1000), randf_range(0,1000), randf_range(0,50000)))
	set_bg_shaders_param("circle_size", 1)
	modulate.a = 0

func _process(delta):
	if queued_for_clearing and not animation_locked:
		fade(global_position - Vector2(0,100), true)
		queued_for_clearing = false

func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
	set_flower_backgrounds(flower_id)
	

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

func move_to_x(new_x : int) -> void:
	animation_locked = true
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position:x", new_x, TIME)
	tween.tween_callback(func(): animation_locked = false)

func fade(target_position : Vector2, fade_out : bool) -> void:
	var target_scale = MIN_SCALE
	if not fade_out:
		target_scale = Vector2.ONE

	var target_opacity = 0 if fade_out else 1
	
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	
	tween.tween_property(self, "global_position", target_position, TIME)
	tween.parallel().tween_property(self, "scale", target_scale, TIME)
	tween.parallel().tween_property(self, "modulate:a", target_opacity, TIME)
	if fade_out:
		tween.tween_callback(queue_free)
	
	
