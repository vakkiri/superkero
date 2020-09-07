extends Node2D

const LEVELS = ["res://level1.tscn", "res://level2.tscn"]
var cur_level = 1
var coins = 0


func next_level():
	coins = find_node("player", true, false).coins
	
	cur_level += 1
	
	if cur_level == 4:
		if coins < 30:
			end()
			return
		else:
			find_node("ui_coin", true, false).visible = false
			find_node("number1", true, false).visible = false
			find_node("number2", true, false).visible = false
	elif cur_level > 4:
		end()
		return

	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://level" +  str(cur_level) + ".tscn").instance())
	var p = find_node("player", true, false)
	p.coins = coins
		
		
func reset():
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://level" +  str(cur_level) + ".tscn").instance())
	var p = find_node("player", true, false)
	p.coins = coins


func end():
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://thanks.tscn").instance())


func restart():
	cur_level = 0
	coins = 0
	next_level()
