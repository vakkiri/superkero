extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body.name == "TileMap":
		get_parent().stick()
	elif body.is_in_group("monsters") and get_parent().is_active():
		body.hit()


