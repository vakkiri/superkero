extends Line2D

enum TONGUE_STATE {
	IDLE,
	FORWARD,
	REVERSE,
	STUCK
}

var state = TONGUE_STATE.IDLE
var out_s = 0
var duration = 0.3
var length = 0
var max_length = 64
var t
var reverse

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if state == TONGUE_STATE.IDLE:
		visible = false
	elif state == TONGUE_STATE.FORWARD:
		out_s += delta
		length = max_length * (out_s / duration)
		visible = true
		if reverse:
			points[1].x = -cos(t) * length
		else:
			points[1].x = cos(t) * length
		points[1].y = sin(t) * length
		if (out_s >= duration):
			state = TONGUE_STATE.IDLE
			out_s = 0
		else:
			$Area2D.position = points[1]
			


func start(t):
	if state == TONGUE_STATE.IDLE:
		state = TONGUE_STATE.FORWARD
		self.t = t
		self.length = 4


func release():
	state = TONGUE_STATE.IDLE
	out_s = 0


