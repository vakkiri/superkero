extends Node2D


var t = 0
var dt = 4.0
var reversed
const tx = 16
const ty = 16
const INIT_DT = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if (reversed):
		set_position(Vector2(tx * cos(t), ty * sin(t)))
	else:
		set_position(Vector2(-tx * cos(t), ty * sin(t)))
	t += dt * delta
	if (t < -1.5 || t > 0.25):
		dt *= -1


func start(player_on_floor):
	dt = -INIT_DT
	if not player_on_floor:
		t = -0.5
	else:
		t = 0.2
	visible = true
	
	
func release():
	visible = false


func set_reverse(reversed):
	self.reversed = reversed
