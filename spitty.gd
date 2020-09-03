extends KinematicBody2D

var spitball = load("res://spitball.tscn")

var FALL_SPEED = 5
var motion = Vector2()
var life
const INVINCE_TIME = 0.5
var invince_timer
var vx = 5

const DIR_TIMER = 6
const ATTACK_TIMER = 3
var attack_timer
var dir_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	invince_timer = 0
	dir_timer = randf() * 6
	life = 4
	attack_timer = ATTACK_TIMER
	$AnimatedSprite.animation = "walk"



func _process(delta):
	$AnimatedSprite.flip_h = vx > 0
	
	if invince_timer > 0:
		invince_timer -= delta
		if int(invince_timer * 100) % 4 == 0:
			visible = false
		else:
			visible = true
	else:
		visible = true
		if attack_timer > 0:
			attack_timer -= delta
		else:
			$AnimatedSprite.animation = "attack"
		
	if not is_on_floor():
		motion.y = FALL_SPEED
		motion.x = vx
		
	if not stunned() and $AnimatedSprite.animation == "walk":
		dir_timer -= delta
		if dir_timer <= 0:
			dir_timer = DIR_TIMER
			vx *= -1
	
		move_and_collide(motion)
		if life <= 0:
			queue_free()
	elif $AnimatedSprite.animation == "attack":
		if randi() % 13 ==0 :
			var ball = spitball.instance()
			if $AnimatedSprite.flip_h:
				ball.vx = 39 + randi() % 6
			else:
				ball.vx = -39 - randi() % 6
			ball.vy = -140 + randi() % 20
			get_parent().add_child(ball)
			ball.position.x = position.x
			ball.position.y = position.y


func hit():
	if invince_timer <= 0:
		life -= 1
		invince_timer = INVINCE_TIME
		$"/root/EnemyHit".play()


func stunned():
	return invince_timer > 0
	
