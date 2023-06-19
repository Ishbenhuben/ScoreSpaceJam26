extends Node

signal tile_clicked(tile_pos:Vector2)
signal flower_cut(flower_id:int)
signal bouquet_made(combo_count:int)

signal ninja_moved_to(new_pos:Vector2)
signal ninja_finished_moving
signal ninja_teleported_to(new_pos:Vector2)

signal round_ended()
signal add_new_result(property:String, value:String)
