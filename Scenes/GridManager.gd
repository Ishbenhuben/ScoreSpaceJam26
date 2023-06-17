extends Node2D

const TILE = preload("res://Scenes/Tile.tscn")

var grid : Array

func _ready():
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
			new_tile.init(Vector2(c,r), get_viewport_rect())
			row.append(new_tile)
		grid.append(row)
	return new_grid
