extends AnimatedSprite


export var heart_num = 1


func _ready():
	offset.y = 8
	offset.x = 10 * heart_num


func _process(_delta):
	var p = get_tree().get_root().find_node("player", true, false)

	if p != null:
		if p.life >= heart_num:
			animation = "full"
		else:
			animation = "empty"
			
	visible = p != null
