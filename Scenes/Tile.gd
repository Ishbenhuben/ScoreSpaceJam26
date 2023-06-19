extends Node2D
class_name Tile

const TILE_SIZE = 128
var tile_coord : Vector2

func _ready():
	Events.connect("round_ended", disable_tile)

func init(xy:Vector2, _vp:Rect2, flower_id:int) -> void:
	tile_coord = xy
	set_position(tile_coord * TILE_SIZE)
	$Flower.set_flower_id(flower_id)

func _on_tile_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			Events.emit_signal("tile_clicked", self)
			#print(tile_coord)

func activate_tile() -> void:
	$TileArea.connect("input_event",_on_tile_area_input_event)
	
func disable_tile() -> void:
	$TileArea.disconnect("input_event",_on_tile_area_input_event)

func cut_flower(next_flower_id:int) -> void:
	$Flower.cut_flower(next_flower_id)
