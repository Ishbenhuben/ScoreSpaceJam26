extends Node2D

const FLOWER = preload("res://Scenes/Flower.tscn")

var flower_dict = {}

func _ready():
	create_flowers()
	reposition_flowers()
	grow_flowers()

func create_flowers() -> void:
	flower_dict = {}
	for col in range(int(1080/GameData.FLOWER_SIZE) + 1):
		for row in range(int(1920/GameData.FLOWER_SIZE) + 1):
			var new_flower = FLOWER.instantiate()
			add_child(new_flower)
			flower_dict[Vector2(col,row)] = new_flower

func reposition_flowers() -> void:
	for coord in flower_dict:
		var random_offset = Vector2(0,0)#randf()*40-20
		var random_scale = Vector2.ONE * (randf()*1+1.2)
		var random_z_index = randi()%5 + 10
		flower_dict[coord].set_position(coord*(GameData.FLOWER_SIZE-0)+random_offset)
		flower_dict[coord].set_scale(random_scale)
		flower_dict[coord].set_z_index(random_z_index)
		
func grow_flowers() -> void:
	for coord in flower_dict:
		flower_dict[coord].set_flower_id(randi()%3, PlayerData.drawing_animation)
