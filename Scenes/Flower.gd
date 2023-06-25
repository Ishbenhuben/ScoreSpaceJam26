extends Node2D

const GROW_TIMER = 2.0
const MAX_SCALE = Vector2.ONE 

const GROWTH_TIME_MULTIPLIER = 0.985

const FLOWER_SIZE = 128

var current_combo = 0
var current_growth = 0

var flower_id : int

var is_fully_grown = false
var current_frame = 0
var max_frame = 10

var drawing_animation = true

var color_tween = null

@onready var backgrounds = [$BG1, $BG2]

func _ready():
	randomize()
	set_bg_shaders_param("background_color", Color('FEFCEF'))
	set_bg_shaders_param("rand", Vector3(randf_range(0,1000), randf_range(0,1000), randf_range(0,50000)))
	Events.connect("bouquet_made", set_combo)
	
func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	if PlayerData.wants_animation:
		$FlowerSheet.set_texture(GameData.FLOWER_SHEETS[flower_id])
		$FlowerSheet.show()
		$FlowerSprite.hide()
	else:
		$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
		$FlowerSprite.show()
		$FlowerSheet.hide()
	
	max_frame = $FlowerSheet.get_texture().get_width()/FLOWER_SIZE
	set_flower_backgrounds(flower_id)
	start_growth()

func cut_flower(next_flower_id:int) -> void:
	if is_fully_grown:
		Events.emit_signal("flower_cut", flower_id)
		color_tween.kill()
		set_shader_circle_size(0.0)
		set_flower_id(next_flower_id)

func get_time_to_next_frame() -> float:
	return GROW_TIMER * pow(GROWTH_TIME_MULTIPLIER,current_combo)/max_frame

func set_combo(combo:int) -> void:
	current_combo = combo
	if PlayerData.wants_animation:
		$Timer.set_wait_time(get_time_to_next_frame())

func start_growth() -> void:
	is_fully_grown = false
	if PlayerData.wants_animation:
		current_frame = 0
		$FlowerSheet.set_region_rect(Rect2(FLOWER_SIZE*current_frame,0,FLOWER_SIZE,FLOWER_SIZE))
		$Timer.set_wait_time(get_time_to_next_frame())
		
	else:
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
		$FlowerSprite.scale = Vector2.ONE * 0.0
		tween.tween_property($FlowerSprite, "scale", Vector2.ONE * MAX_SCALE, GROW_TIMER)
		$Timer.set_wait_time(GROW_TIMER)
		#TODO depende sa speed yung delta
		
	$Timer.start()

func _on_next_frame_timer_timeout() -> void:
	if PlayerData.wants_animation:
		current_frame += 1
		if current_frame == max_frame:
			set_fully_grown()
			color_flower()
		else:
			$FlowerSheet.set_region_rect(Rect2(FLOWER_SIZE*current_frame,0,FLOWER_SIZE,FLOWER_SIZE))
			$Timer.start()
	else:
		set_fully_grown()
		color_flower()

func color_flower() -> void:
	color_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	color_tween.tween_method(set_shader_circle_size, 0.0, 0.5, 0.1)

func set_fully_grown() -> void:
	is_fully_grown = true

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
