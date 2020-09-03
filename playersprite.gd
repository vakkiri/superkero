extends AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("animation_finished", self, "on_animation_end")


func on_animation_end():
	if animation == "teleport":
		get_tree().get_root().find_node("root", true, false).next_level()
