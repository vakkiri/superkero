extends AnimatedSprite


func _ready():
	pass # Replace with function body.

func _process(delta):
	var p = get_tree().get_root().find_node("player", true, false)
	frame = int(p.coins) % 10
