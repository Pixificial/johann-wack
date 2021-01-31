extends KinematicBody2D

const MOVEMENT_SPEED = 60.0
const JUMP_SPEED = 320.0
#DOESNT WORK FIX 6TH LINE AFTER IMPLEMENTING BULLETZ
onready var enemy_bullet = preload("res://assets/scenes/subscenes/enemy_bullet/enemy_bullet_area_2d.tscn")
var enemy01_sprite


var horizontal_movement_direction : float

var velocity : Vector2

var _jump_input_recieved : bool
var _shoot_timer = 0.0
var _shoot_timer_duration = 1.0
var _jump_cooldown_timer = 0
var _jump_cooldown_timer_duration = 1.0
var _last_frame_position

var character_found = false
var character
var chasing = false

var health = 20.0

func _ready():
	enemy01_sprite = get_node("Enemy01Sprite")

func _process(delta):
	_handle_shoot_timer(delta)
	_handle_jump_cooldown_timer(delta)
	_handle_input()

func _physics_process(delta):
	_last_frame_position = position
	if (_jump_input_recieved && is_on_floor()):
		_jump_input_recieved = false
		velocity.y = -JUMP_SPEED
	velocity.x = horizontal_movement_direction * MOVEMENT_SPEED
	if (velocity.y < 500.0):
		velocity.y += Global.get_gravity() * delta
	if (character_found):
		enemy01_sprite.scale.x = -sign(character.position.x - position.x)
	velocity = move_and_slide(velocity, Vector2.UP)

func _handle_positiontal_input():
	horizontal_movement_direction = 0.0
	if (character_found):
		if (abs(character.position.x - position.x) > 210.0):
			chasing = true
			if (character.position.x - position.x > 0.0):
				horizontal_movement_direction += 1.0
			if (character.position.x - position.x < 0.0):
				horizontal_movement_direction -= 1.0
			if (abs(_last_frame_position.x - position.x) <= 0.5 && _jump_cooldown_timer <= 0.0):
				_jump_input_recieved = true
				_jump_cooldown_timer = _jump_cooldown_timer_duration

		else:
			chasing = false
			if (abs(character.position.x - position.x) < 2.0 && character.position.y - position.y < -2.0 && _jump_cooldown_timer <= 0.0):
				_jump_input_recieved = true
				_jump_cooldown_timer = _jump_cooldown_timer_duration
	

func _handle_shoot_input():
	if (!chasing && _shoot_timer <= 0.0 && character_found):
		_shoot_timer = _shoot_timer_duration
		var bullet = enemy_bullet.instance()
		get_tree().get_root().add_child(bullet)
		bullet.position = position
		bullet.velocity = Vector2(sign(character.position.x - position.x) * bullet.BASE_SPEED, 0)
		
func _handle_shoot_timer(delta):
	if (_shoot_timer > 0.0):
		_shoot_timer -= delta

func _handle_jump_cooldown_timer(delta):
	if (_jump_cooldown_timer > 0.0):
		_jump_cooldown_timer -= delta

func _handle_input():
	_handle_positiontal_input()
	_handle_shoot_input()

func _on_DetectionArea2D_body_entered(var body):
	character_found = true
	character = body
	print(character)

func get_hurt(var damage):
	health -= damage
	if (health <= 0.0):
		queue_free()
