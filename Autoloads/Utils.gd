extends Node


func xor(statement_1 : bool, statement_2 : bool) -> bool:
	return (statement_1 and not statement_2) or (not statement_1 and statement_2)
