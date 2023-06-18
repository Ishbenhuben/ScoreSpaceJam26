extends Control

var basket = []
var basket_capacity = 3

var bouquets_made = 0

func _ready():
	Events.connect("flower_cut", flower_cut)

func init_basket() -> void:
	basket = []
	for i in range(basket_capacity):
		var new_flower = TextureRect.new()
		$Basket.add_child(new_flower)

func start_round() -> void:
	bouquets_made = 0
	init_basket()

func flower_cut(flower_id:int) -> void:
	basket.append(flower_id)
	if len(basket) > basket_capacity:
		basket.pop_front()
		
	if check_basket():
		basket = []
		print("BASKET")
	update_basket_visual()

func update_basket_visual() -> void:
	for i in range(basket_capacity):
		var flower_sprite = $Basket.get_child(i)
		flower_sprite.set_texture(null)
		if i < len(basket):
			flower_sprite.set_texture(GameData.FLOWER_TEXTURES[basket[i]])

func check_basket() -> bool:
	if len(basket) < basket_capacity:
		return false
	var flower = basket[0]
	for i in range(1,basket_capacity):
		if basket[i] != flower:
			return false
	return true
	

