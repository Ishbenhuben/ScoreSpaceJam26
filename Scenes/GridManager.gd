extends Node2D

const TILE = preload("res://Scenes/Tile.tscn")
const GRID_SIZE = 4

var grid : Array
var ninja_position : Vector2 = Vector2.ZERO
var flower_deck : Array
var move_queue : Array

@onready var ninja = $Ninja

func _ready():
	randomize()
	Events.connect("tile_clicked", handle_tile_press)
	Events.connect("ninja_finished_moving", try_moving)

func ready_round() -> void:
	init_grid(GRID_SIZE)
	ninja.ready_round()
	Events.ninja_teleported_to.emit(get_grid_tile(ninja_position).global_position)

func start_round() -> void:
	for col in range(len(grid)):
		for row in range(len(grid[col])):
			grid[col][row].activate_tile()

func init_grid(grid_length:int) -> void:
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

func get_grid_tile(coord : Vector2):
	if coord.x >= 0 and coord.x < GRID_SIZE:
		if coord.y >= 0 and coord.y < GRID_SIZE:
			return grid[coord.y][coord.x]
	return null

func handle_tile_press(tile : Tile) -> void:
	move_queue.append(tile)
	try_moving()

func try_moving() -> void:
	if ninja.tween: # he still moving
		return
	while len(move_queue) > 0:
		var tile = move_queue.pop_front()
		var delta = (tile.tile_coord - ninja_position)
		if Utils.xor(delta.x == 0, delta.y == 0):
			cut_flowers_from_to(ninja_position, tile.tile_coord)
			ninja_position = tile.tile_coord
			Events.ninja_moved_to.emit(tile.global_position)
			break
		else:
			highlight_valid_tiles()

func reset_flower_deck() -> void:
	var dupes = 4
	flower_deck = []
	for i in range(3):
		for j in range(dupes):
			flower_deck.append(i)
	flower_deck.shuffle()

func draw_flower_deck() -> int:
	if flower_deck == []:
		reset_flower_deck()
	return flower_deck.pop_back()

func cut_flowers_from_to(from:Vector2, to:Vector2) -> void:
	var delta
	if from.x == to.x: #vertical
		delta = sign(to.y - from.y)
		while from != to:
			from.y += delta
			cut_flower_on_tile(from)
	else: # horizontal
		delta = sign(to.x - from.x)
		while from != to:
			from.x += delta
			cut_flower_on_tile(from)

func highlight_valid_tiles():
	for r in range(GRID_SIZE):
		grid[ninja_position.x][r].highlight_tile()
	for c in range(GRID_SIZE):
		grid[c][ninja_position.y].highlight_tile()

func cut_flower_on_tile(tile_pos:Vector2) -> void:
	grid[tile_pos.x][tile_pos.y].cut_flower(draw_flower_deck())
