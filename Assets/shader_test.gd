extends Node2D

var x  = 0

func _process(delta):
	x += 1
	material.set("shader_param/iTime", x)
