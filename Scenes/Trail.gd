class_name Trail
extends Line2D

@export var target_path: NodePath
@export var max_points := 500
@export var resolution := 5.0
@export var lifetime := 0.3
@export var offset := Vector2.ZERO

@onready var target: Node2D


var _last_point := Vector2.ZERO
var _points_creation_time := []
var _clock := 0.0


func _ready() -> void:

	target = get_parent() as Node2D
	set_as_top_level(true)
	position = Vector2.ZERO
	clear_points()
	_last_point = to_local(target.global_position)

func _process(delta: float) -> void:
	_clock += delta
	remove_older()
	var desired_point := to_local(target.global_position + offset)
	var distance := _last_point.distance_to(desired_point)
	if distance > resolution:
		add_timed_point(desired_point, _clock)
	if get_point_count() > max_points:
		remove_point(0)

func add_timed_point(point: Vector2, time: float) -> void:
	add_point(point)
	_points_creation_time.append(time)
	_last_point = point
	if get_point_count() > max_points:
		remove_first_point()

func remove_first_point() -> void:
	if get_point_count() > 1:
		remove_point(0)
	_points_creation_time.pop_front()

func remove_older() -> void:
	for creation_time in _points_creation_time:
		var delta = _clock - creation_time
		if delta > lifetime:
			remove_first_point()
		else:
			break
