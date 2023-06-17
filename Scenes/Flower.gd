extends Node2D

const GROW_TIMER = 1.5

var current_growth = 0

var flower_id : int

func _ready():
	$GrowthTimer.wait_time = GROW_TIMER

func _process(delta) -> void:
	$FlowerSprite.set_scale((GROW_TIMER-$GrowthTimer.time_left)/GROW_TIMER * Vector2(1,1))

func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
	cut_flower()
	start_growth()

func cut_flower() -> void:
	current_growth = 0

func start_growth() -> void:
	$GrowthTimer.start()
