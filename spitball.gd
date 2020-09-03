extends Area2D

var vx
var vy
const G = 330


func _ready():
	connect("body_entered", self, "_on_body_entered")
	

func _on_body_entered(body):
	if body.name == "TileMap":
		queue_free()
	elif body.name == "player":
		body.hit()


func _process(delta):
	vy += G * delta
	
	position.x += vx * delta
	position.y += vy * delta
	
	if position.y >= 700 / 4 or vy > 500:
		queue_free()
