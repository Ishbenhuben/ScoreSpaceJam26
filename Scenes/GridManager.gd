extends Node2D

const TILE = preload("res://Scenes/Tile.tscn")
const GRID_SIZE = 4

var grid : Array
var ninja_position : Vector2 = Vector2.ZERO



func _ready():
	init_grid(GRID_SIZE)
	Events.ninja_teleported_to.emit(get_grid_tile(ninja_position).global_position)

	

func init_grid(grid_length:int) -> void:
	var row
	var new_tile
	for c in range(grid_length):
		row = []
		for r in range(grid_length):
			new_tile = TILE.instantiate()
			add_child(new_tile)
			new_tile.init(Vector2(c,r), get_viewport_rect())
			new_tile.pressed.connect(handle_tile_press)
			row.append(new_tile)
		grid.append(row)


func get_grid_tile(coord : Vector2):
	if coord.x >= 0 and coord.x < GRID_SIZE:
		if coord.y >= 0 and coord.y < GRID_SIZE:
			return grid[coord.y][coord.x]
	return null


func handle_tile_press(tile : Tile) -> void:
	
	var delta = (tile.tile_coord - ninja_position)
	if Utils.xor(delta.x == 0, delta.y == 0):
		ninja_position = tile.tile_coord
		Events.ninja_moved_to.emit(tile.global_position)
