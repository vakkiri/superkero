extends Line2D

enum TONGUE_STATE {
	IDLE,
	FORWARD,
	REVERSE,
	STUCK
}

var state = TONGUE_STATE.IDLE
var out_s = 0
var duration = 0.2
var length = 0
var max_length = 64
var t
var reverse
var vx
const MAX_VX = 4
const ACCEL = 0.2
const DECAY = 0.98
# Called when the node enters the scene tree for the first time.
func _ready():
	vx = 0


func _physics_process(delta):
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



func handle_movement(dx, dy):
	if state == TONGUE_STATE.STUCK:
		points[1].x -= dx
		points[1].y -= dy
		length	= sqrt((points[1].x * points[1].x) + (points[1].y * points[1].y))
		if points[1].y >= 0 or length > max_length:
			points[1].y = -0.1
			release()


func start(t):
	vx = get_parent().dx * 1.0
	if state == TONGUE_STATE.IDLE:
		state = TONGUE_STATE.FORWARD
		self.t = t
	elif state == TONGUE_STATE.STUCK:
		release()


func release():
	if state == TONGUE_STATE.STUCK:
		get_parent().vx = vx * 800
		
	state = TONGUE_STATE.IDLE
	out_s = 0
	$Area2D.position = Vector2(0, 0)



func stick():
	if state == TONGUE_STATE.FORWARD:
		state = TONGUE_STATE.STUCK
		get_parent().stick()


func stuck():
	return state == TONGUE_STATE.STUCK


func rotate_tongue(delta):
	var cdx = points[1].x
	var cdy = points[1].y
	var cdx2
	var cdy2
	var dx
	var dy
	
	if points[1].x > 0:
		vx += ACCEL * ((max_length - cdx) / max_length)
	elif points[1].x < 0:
		vx -= ACCEL * ((max_length + cdx) / max_length)
	
	vx *= DECAY
	
	if vx > MAX_VX:
		vx = MAX_VX
	if vx < -MAX_VX:
		vx = -MAX_VX
	
	dx = vx
	var l = sqrt((cdx * cdx) + (cdy * cdy))
	
	cdx2 = cdx - dx
	if (l > abs(cdx2)):
		cdy2 = sqrt((l * l) - (cdx2 * cdx2))
		dy = cdy + cdy2
	else:
		dy = 0
		release()
	
	return Vector2(4 * dx / delta, 4 * dy / delta)


func is_active():
	return state != TONGUE_STATE.IDLE

