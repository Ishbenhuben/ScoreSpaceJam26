extends Node2D
class_name Tile

const TILE_SIZE = 144
var tile_coord : Vector2

var shiver = false

var highlight_tween = null
const HIGHLIGHT_MIN_SIZE = 0.89
const HIGHLIGHT_TIME = 0.25

func _ready():
	Events.connect("round_ended", disable_tile)
	Events.connect("shiver", toggle_shiver)

func init(xy:Vector2, _vp:Rect2, flower_id:int) -> void:
	tile_coord = xy
	set_position(tile_coord * TILE_SIZE)
	$Flower.set_flower_id(flower_id, PlayerData.drawing_animation)

func _on_tile_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			Events.emit_signal("tile_clicked", self)
			#print(tile_coord)

func activate_tile() -> void:
	$Area.connect("input_event",_on_tile_area_input_event)
	
func disable_tile() -> void:
	$Area.disconnect("input_event",_on_tile_area_input_event)

func cut_flower(next_flower_id:int) -> void:
	$Flower.cut_flower(next_flower_id)

func highlight_tile():
	if highlight_tween and highlight_tween.is_running():
		return
	highlight_tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	$Highlight.scale = Vector2.ONE
	highlight_tween.tween_property($Highlight, "scale", Vector2.ONE * HIGHLIGHT_MIN_SIZE, HIGHLIGHT_TIME/2)
	highlight_tween.tween_property($Highlight, "scale", Vector2.ONE, HIGHLIGHT_TIME/2)

func toggle_shiver(will_shiver:bool) -> void:
	shiver = will_shiver

func _process(delta):
	if shiver:
		set_rotation_degrees(randf()*4-2)
	else:
		set_rotation_degrees(0)

func _on_area_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			Events.emit_signal("tile_clicked", self)
