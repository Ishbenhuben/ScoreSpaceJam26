extends Node


func xor(statement_1 : bool, statement_2 : bool) -> bool:
	return (statement_1 and not statement_2) or (not statement_1 and statement_2)

func seconds_to_string(seconds:float) -> String:
	var mins = floor(seconds/60)
	return "%d:%.2f" % [mins, fmod(seconds, 60)]
