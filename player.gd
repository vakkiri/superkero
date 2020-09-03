extends KinematicBody2D

var life = 3
var coins = 0

const INVINCE_TIME = 0.5
var invince_timer = 0

var target
var holdingOrb
var facingLeft
var motion = Vector2()
var stuck
const UP = Vector2(0, -1)
const GRAVITY = 20
const SPEED = 280
const MAX_SPEED = 280
const SPEED_ACCEL = 50
const JUMP = -580
const FRICTION = 25
const AIR_DRAG = 12

var left_pressed_last = false

var MAX_Y = 550
var vx = 0
var vy = 0
var dx = 0
var dy = 0

func _ready():
	$AnimatedSprite.animation = "idle"
	set_process(true)
	$indicator.release()
	stuck = false
	facingLeft = false
	vx = 0
	life = 3
	coins = 0


func handle_gravity(delta):
	if $tongue.stuck() and not is_on_floor():
		if not is_on_wall():
			motion = $tongue.rotate_tongue(delta)
		else:
			$tongue.vx = 0
			motion = Vector2(0, 0)
			vx = 0
	else:
		if Input.is_action_pressed("jump"):
			motion.y += GRAVITY
		else:
			motion.y += GRAVITY * 2


func handle_action():
	if Input.is_action_just_pressed("action") and not $tongue.stuck():
		$indicator.start(is_on_floor())
	elif Input.is_action_just_released("action"):
		if Input.is_action_just_released("action"):
			$tongue.start($indicator.t)
		$indicator.release()
		$tongue.reverse = facingLeft


func handle_movement():
	facingLeft = left_pressed_last and not (Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left")) or (Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"))
			
	if not $tongue.stuck():
		var dvx
		if is_on_floor():
			dvx = FRICTION
		else:
			dvx = AIR_DRAG
		if vx > 0:
			vx = max(vx - dvx, 0)
		elif vx < 0:
			vx = min(vx + dvx, 0)
			
		if Input.is_action_pressed("ui_right") and not (Input.is_action_pressed("ui_left") and left_pressed_last):
			if not $tongue.stuck():
				if vx < 0:
					vx += SPEED_ACCEL * 2
				else:
					vx += SPEED_ACCEL
		elif Input.is_action_pressed("ui_left") and not (Input.is_action_pressed("ui_right") and not left_pressed_last):
			if not $tongue.stuck():
				if vx > 0:
					vx -= SPEED_ACCEL * 2
				else:
					vx -= SPEED_ACCEL
					
		motion.x = vx
		
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = facingLeft
					
		if motion.x != 0:
			$AnimatedSprite.animation = "run"
		else:
			$AnimatedSprite.animation = "idle"


func _physics_process(delta):
	if Input.is_action_just_pressed("ui_right"):
		left_pressed_last = false
	if Input.is_action_just_pressed("ui_left"):
		left_pressed_last = true
		
	if $AnimatedSprite.animation != "teleport":
		if invince_timer > 0:
			invince_timer -= delta
			if int(invince_timer * 100) % 4 == 0:
				visible = false
			else:
				visible = true
		else:
			visible = true
			if life <= 0:
				die()
			
			
		find_node("indicator").set_reverse(!facingLeft)
		
		if is_on_floor() and $tongue.stuck() and (Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left")):
			$tongue.release()
			
		handle_gravity(delta)
		
		if (motion.y > MAX_Y):
			motion.y = MAX_Y
		if (vx > MAX_SPEED):
			vx = MAX_SPEED
		if (vx < -MAX_SPEED):
			vx = -MAX_SPEED
		
		handle_action()
		handle_movement()
		
		if is_on_floor():
			if Input.is_action_just_pressed("jump"):
				motion.y = JUMP
				$AnimatedSprite.animation = "jump"
				$"/root/JumpSound".play()
		elif $tongue.stuck():
			if Input.is_action_just_pressed("jump"):
				motion.y = JUMP
				$"/root/JumpSound".play()
				$tongue.release()
		
		var prex = position.x
		var prey = position.y
		motion = move_and_slide(motion, UP)
		dx = position.x - prex
		dy = position.y - prey
		
		if $tongue.is_active():
			$AnimatedSprite.animation = "open"
			
		$tongue.handle_movement(dx, dy)
		
		if position.y >= 700 / 4:
			die()

func stick():
	stuck = true


func hit():
	if invince_timer <= 0:
		life -= 1
		invince_timer = INVINCE_TIME


func die():
	get_tree().get_root().find_node("root", true, false).reset()


func teleport():
	$AnimatedSprite.animation = "teleport"
	

