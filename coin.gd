extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "player":
		queue_free()
		$"/root/CoinSound".play()
		body.coins += 1
