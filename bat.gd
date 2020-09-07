extends KinematicBody2D

var FALL_SPEED = 0
var motion = Vector2()
var life
const INVINCE_TIME = 0.5
var invince_timer
var vx = 0.5

const DIR_TIMER = 1.5
var dir_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	invince_timer = randf() * 1
	dir_timer = (randf() * 1.5) - 0.5
	life = 2



func _process(delta):
	if invince_timer > 0:
		invince_timer -= delta
		if int(invince_timer * 100) % 4 == 0:
			visible = false
		else:
			visible = true
	else:
		visible = true
		
	if not is_on_floor():
		motion.y = FALL_SPEED
		motion.x = vx
		
	if not stunned():
		dir_timer -= delta
		if dir_timer <= 0:
			dir_timer = DIR_TIMER
			vx *= -1
			$AnimatedSprite.flip_h = vx > 0
	
		move_and_collide(motion)
		if life <= 0:
			queue_free()
	


func hit():
	if invince_timer <= 0:
		life -= 1
		invince_timer = INVINCE_TIME
		$"/root/EnemyHit".play()


func stunned():
	return invince_timer > 0
