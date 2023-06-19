extends Control

var basket = []
var flowers_array = []
var basket_capacity = 3

var bouquets_made = 0

var combo_timer = 3.0
var current_combo = 0

var Flower = preload("res://Scenes/small_flower.tscn")

var ignore = null

var animation_lock : bool = false

func _ready():
	Events.connect("flower_cut", flower_cut)
	$Combo/Combo_Timer.wait_time = combo_timer

func init_basket() -> void:
	basket = []


func start_round() -> void:
	bouquets_made = 0
	current_combo = 0
	init_basket()

func flower_cut(flower_id:int) -> void:	
	if len(basket) >= basket_capacity:
		pop_basket_front()
	add_flower_to_basket(flower_id)
	if check_basket():
		clear_basket()
		bouquets_made += 1
		$Score/Score_Label.set_text(str(bouquets_made))
		Events.emit_signal("bouquet_made", get_combo())



func check_basket() -> bool:
	if len(basket) < basket_capacity:
		return false
	var flower = basket[0]
	for i in range(1,basket_capacity):
		if basket[i] != flower:
			return false
	return true

func clear_basket() -> void:
	basket.clear()
	for flower in flowers_array:
		flower.queued_for_clearing = true
	flowers_array.clear()
	update_basket_visual()

func pop_basket_front() -> void:
	basket.pop_front()
	flowers_array.pop_front().fade(Vector2(240, $Basket.get_child(0).global_position.y), true)

func get_positions_array(count : int) -> Array:
	var pos_x = []
	if count == 0:
		return []
	match (count):
		1: pos_x = [540]
		2: pos_x = [440,640]
		3: pos_x = [340,540,740]
	return pos_x

func update_basket_visual() -> void:
	var count = basket.size()
	var pos_x = get_positions_array(count)
	for i in range(flowers_array.size()):
		flowers_array[i].move_to_x(pos_x[i])


func add_flower_to_basket(flower_id : int) -> void:
	basket.append(flower_id)
	var new_flower = Flower.instantiate()
	$Basket.add_child(new_flower)
	flowers_array.append(new_flower)
	new_flower.global_position.x = 840
	new_flower.set_flower_id(flower_id)
	var pos_x = get_positions_array(basket.size())[basket.size()-1]
	new_flower.fade(Vector2(pos_x, new_flower.global_position.y), false)
	update_basket_visual()

func get_combo() -> int:
	if $Combo/Combo_Timer.time_left > 0: # combo on going
		current_combo += 1
	else: # new combo
		current_combo = 1
	update_combo_visual()
	#print(current_combo)
	$Combo/Combo_Timer.start()
	return current_combo

func _on_combo_timer_timeout():
	current_combo = 0
	update_combo_visual()

func update_combo_visual() -> void:
	if current_combo > 0:
		$Combo/Combo_Label.set_text("x%d" % current_combo)
		$Combo.show()
	else:
		$Combo.hide()

func _process(_delta) -> void:
	$Combo/Combo_Label/Combo_timer_label.set_text("%.2f" % $Combo/Combo_Timer.time_left)
