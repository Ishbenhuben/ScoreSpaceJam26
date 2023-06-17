extends Node2D
class_name Tile

const TILE_SIZE = 64
var tile_coord : Vector2

signal pressed(xy)
	
func _ready():
	pass # Replace with function body.

func init(xy:Vector2, _vp:Rect2, flower_id:int) -> void:
	tile_coord = xy
	set_position(tile_coord * TILE_SIZE)
	$Flower.set_flower_id(flower_id)

func _on_tile_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			pressed.emit(self)
			print(tile_coord)
