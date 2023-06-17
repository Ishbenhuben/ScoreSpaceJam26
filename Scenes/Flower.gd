extends Node2D

const GROW_TIMER = 1.5

var current_growth = 0

var flower_id : int

func _ready():
	$GrowthTimer.wait_time = GROW_TIMER

func _process(_delta) -> void:
	$FlowerSprite.set_scale((GROW_TIMER-$GrowthTimer.time_left)/GROW_TIMER * Vector2(1,1))

func set_flower_id(f_id:int) -> void:
	flower_id = f_id
	$FlowerSprite.set_texture(GameData.FLOWER_TEXTURES[flower_id])
	start_growth()

func cut_flower(next_flower_id:int) -> void:
	if $GrowthTimer.time_left == 0:
		Events.emit_signal("flower_cut", flower_id)
		set_flower_id(next_flower_id)

func start_growth() -> void:
	$GrowthTimer.start()
