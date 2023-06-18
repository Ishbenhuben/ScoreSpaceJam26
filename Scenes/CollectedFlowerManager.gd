extends Control

var basket = []
var basket_capacity = 3

func _ready():
	Events.connect("flower_cut", flower_cut)

func init_basket() -> void:
	basket = []
	for i in range(basket_capacity):
		var new_flower = TextureRect.new()
		$Basket.add_child(new_flower)
		new_flower.set_texture(GameData.FLOWER_TEXTURES[0])

func start_round() -> void:
	init_basket()

func flower_cut(flower_id:int) -> void:
	basket.append(flower_id)
	if len(basket) > basket_capacity:
		basket.pop_front()
		
	update_basket_visual()
	check_basket()

func update_basket_visual() -> void:
	for i in range(basket_capacity):
		var flower_sprite = $Basket.get_child(i)
		flower_sprite.set_texture(null)
		if i < len(basket):
			flower_sprite.set_texture(GameData.FLOWER_TEXTURES[basket[i]])
			

func check_basket() -> void:
	pass

