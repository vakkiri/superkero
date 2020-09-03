extends AnimatedSprite


func _ready():
	connect("animation_finished", self, "on_animation_end")


func on_animation_end():
	if animation == "attack":
		animation = "walk"
		get_parent().attack_timer = get_parent().ATTACK_TIMER
