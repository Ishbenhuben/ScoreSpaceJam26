extends Node2D

const TILE = preload("res://Scenes/Tile.tscn")

var grid : Array
var flower_deck : Array

func _ready():
	randomize()
	grid = init_grid(4)

func init_grid(grid_length:int) -> Array:
	var new_grid = []
	var row
	var new_tile
	for c in range(grid_length):
		row = []
		for r in range(grid_length):
			new_tile = TILE.instantiate()
			add_child(new_tile)
			new_tile.init(Vector2(c,r), get_viewport_rect(), draw_flower_deck())
			row.append(new_tile)
		grid.append(row)
	return new_grid

func reset_flower_deck() -> void:
	var dupes = 2
	flower_deck = []
	for i in range(3):
		for j in range(dupes):
			flower_deck.append(i)
	flower_deck.shuffle()

func draw_flower_deck() -> int:
	if flower_deck == []:
		reset_flower_deck()
	return flower_deck.pop_back()

func cut_flower_on_tile(tile_pos:Vector2) -> void:
	grid[tile_pos.x][tile_pos.y].cut_flower(draw_flower_deck())
