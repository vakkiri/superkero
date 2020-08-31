extends KinematicBody2D


var target
var holdingOrb
var doubleJump
var facingLeft
var action_held
var motion = Vector2()
const UP = Vector2(0, -1)
const GRAVITY = 1400
const SPEED = 16000
const JUMP = -43000

var MAX_Y = 100000

func _ready():
	set_process(true)
	doubleJump = false
	action_held = false

func _physics_process(delta):
	
	if Input.is_action_pressed("jump"):
		motion.y += GRAVITY * delta
	else:
		motion.y += GRAVITY * delta * 2
	
	if (motion.y > MAX_Y):
		motion.y = MAX_Y
	
	if Input.is_action_pressed("action"):
		find_node("indicator").set_reverse(!facingLeft)
		if not action_held:
			find_node("indicator").start()
			action_held = true
	else:
		if action_held:
			var indicator = find_node("indicator")
			find_node("tongue").start(indicator.t)
		find_node("indicator").release()
		find_node("tongue").reverse = facingLeft
		action_held = false
		
	if Input.is_action_pressed("ui_right"):
		facingLeft = false
		motion.x = SPEED * delta
	elif Input.is_action_pressed("ui_left"):
		facingLeft = true
		motion.x = -SPEED * delta
	else:
		motion.x = 0
		
	if motion.x != 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = motion.x < 0
	else:
		$AnimatedSprite.animation = "idle"
	
	if is_on_floor():
		doubleJump = true
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP * delta
			$AnimatedSprite.animation = "jump"
	elif (doubleJump):
		if Input.is_action_just_pressed("jump"):
			motion.y = JUMP * delta
			doubleJump = false
		
	motion = move_and_slide(motion, UP)
		
