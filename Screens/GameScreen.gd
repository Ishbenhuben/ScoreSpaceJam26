extends Control


func _ready():
	$GridManager.start_round()
	$Ninja.start_round()
	$TimeManager.start_round()
