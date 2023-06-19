extends Control

var basket = []
var basket_capacity = 3

var bouquets_made = 0

var combo_timer = 2.0
var current_combo = 0
var max_combo = 0

var current_score = 0
var score_per_bouquet = 100
var score_per_combo = 25

func _ready():
	Events.connect("flower_cut", flower_cut)
	Events.connect("round_ended", end_round)
	$Combo/Combo_Timer.wait_time = combo_timer

func init_basket() -> void:
	basket = []
	for i in range(basket_capacity):
		var new_flower = TextureRect.new()
		$Basket.add_child(new_flower)

func ready_round() -> void:
	current_score = 0
	bouquets_made = 0
	current_combo = 0
	max_combo = 0
	init_basket()

func start_round() -> void:
	pass

func flower_cut(flower_id:int) -> void:
	basket.append(flower_id)
	if len(basket) > basket_capacity:
		basket.pop_front()
		
	if check_basket():
		basket = []
		bouquets_made += 1
		var combo = get_combo()
		update_score(combo)
		Events.emit_signal("bouquet_made", combo)
	update_basket_visual()

func check_basket() -> bool:
	if len(basket) < basket_capacity:
		return false
	var flower = basket[0]
	for i in range(1,basket_capacity):
		if basket[i] != flower:
			return false
	return true
	
func update_basket_visual() -> void:
	for i in range(basket_capacity):
		var flower_sprite = $Basket.get_child(i)
		flower_sprite.set_texture(null)
		if i < len(basket):
			flower_sprite.set_texture(GameData.FLOWER_TEXTURES[basket[i]])

func get_combo() -> int:
	if $Combo/Combo_Timer.time_left > 0: # combo on going
		current_combo += 1
	else: # new combo
		current_combo = 1
	max_combo = max(max_combo, current_combo)
	update_combo_visual()
	
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

func update_score(combo:int) -> void:
	current_score += score_per_bouquet + score_per_combo*(combo-1)
	$Score/Score_Label.set_text(str(current_score))

func end_round() -> void:
	Events.emit_signal("add_new_result", "score", str(current_score))
	Events.emit_signal("add_new_result", "max_combo", str(max_combo))
	Events.emit_signal("add_new_result", "bouquets", str(bouquets_made))
