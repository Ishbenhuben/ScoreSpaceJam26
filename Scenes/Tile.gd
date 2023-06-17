extends Node2D
class_name Tile

const TILE_SIZE = 64
var tile_coord : Vector2

func _ready():
	#Events.connect(new_tile, handle_tile_press)
	pass

func init(xy:Vector2, _vp:Rect2, flower_id:int) -> void:
	tile_coord = xy
	set_position(tile_coord * TILE_SIZE)
	$Flower.set_flower_id(flower_id)

func _on_tile_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			Events.emit_signal("tile_clicked", self)
			print(tile_coord)

func cut_flower(next_flower_id:int) -> void:
	$Flower.cut_flower(next_flower_id)
