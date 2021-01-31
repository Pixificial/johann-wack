extends Area2D

const BASE_SPEED = 400.0

var velocity = Vector2()
var life_timer = 6.0 #Should normally use a single global timer, but I'm on a timer myself
var damage = 10.0

func _physics_process(delta):
	if (life_timer > 0.0):
		life_timer -= delta
	else:
		queue_free() 
	position += velocity * delta

func _on_EnemyBulletArea2D_body_entered(var body):
	if(body.get_name() == "CharacterKinematicBody2D"):
		Global.hurt_player(damage)
		queue_free()
	else:
		queue_free()
