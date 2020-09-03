extends Node2D

const LEVELS = ["res://level1.tscn", "res://level2.tscn"]
var cur_level = 1


func next_level():
	cur_level += 1
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://level" +  str(cur_level) + ".tscn").instance())
		
		
func reset():
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://level" +  str(cur_level) + ".tscn").instance())

