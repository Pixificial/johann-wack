extends KinematicBody2D

const BASE_SPEED = 400.0

var velocity = Vector2()
var life_timer = 6.0 #Should normally use a single global timer, but I'm on a timer myself


func _physics_process(delta):
	if (life_timer > 0.0):
		life_timer -= delta
	else:
		queue_free() 
	velocity = move_and_slide(velocity, Vector2.UP)
