extends Node


func xor(statement_1 : bool, statement_2 : bool) -> bool:
	return (statement_1 and not statement_2) or (not statement_1 and statement_2)

func seconds_to_string(seconds:float) -> String:
	var mins = floor(seconds/60)
	return "%d:%2.2f" % [mins, fmod(seconds, 60)]

func phantomize(label:Label, dest:Vector2, duration:float) -> void:
	var new_phantom = label.duplicate()
	label.get_parent().add_child(new_phantom)
	new_phantom.show()
	var tween = get_tree().create_tween()
	tween.tween_method(new_phantom.set_position, new_phantom.position, new_phantom.position+dest, duration)
	tween.parallel().tween_property(new_phantom, "modulate:a", 0, duration)
	tween.tween_callback(new_phantom.queue_free)
