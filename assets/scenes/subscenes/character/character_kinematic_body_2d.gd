extends KinematicBody2D

const MOVEMENT_SPEED = 120.0
const JUMP_SPEED = 320.0

onready var character_bullet = preload("res://assets/scenes/subscenes/character_bullet/character_bullet_area_2d.tscn")
onready var idle_sprite = preload("res://assets/scenes/subscenes/character/character_idle.png")
onready var run_sprite = preload("res://assets/scenes/subscenes/character/character_run.png")
onready var walk_sfx_1 = preload("res://assets/scenes/subscenes/character/gravelwalksol1.wav")
onready var walk_sfx_2 = preload("res://assets/scenes/subscenes/character/gravelwalksol2.wav")
onready var walk_sfx_3 = preload("res://assets/scenes/subscenes/character/gravelwalksag1.wav")
onready var walk_sfx_4 = preload("res://assets/scenes/subscenes/character/gravelwalksag2.wav")
var walk_sfxs

var character_sprite
var animation_player
var walk_audio_stream_player

var character_jump : bool
var character_left : bool
var character_down : bool
var character_right : bool
var character_shoot : bool
var horizontal_input_direction : float
var last_horizontal_input_direction = 1.0

var velocity : Vector2

var _jump_input_recieved : bool
var _shoot_timer = 0.0
var _shoot_timer_duration = 0.3
var _walk_audio_timer = 0
var _walk_audio_timer_duration = 0.63
var damage = 10.0

var is_operational = false
var is_operational_timer = 2.0

func _ready():
	character_sprite = get_node("CharacterSprite")
	animation_player = get_node("CharacterSprite/AnimationPlayer")
	walk_audio_stream_player = get_node("WalkAudioStreamPlayer2D")
	walk_sfxs =  [walk_sfx_1, walk_sfx_2, walk_sfx_3, walk_sfx_4]

func _process(delta):
	_handle_is_operational_timer(delta) #Bad code, but crunching so *shrug*
	if (is_operational):
		_handle_shoot_timer(delta)
		_handle_input()
		if (horizontal_input_direction != 0.0):
			character_sprite.texture = run_sprite
			animation_player.current_animation = "run"
			if (_walk_audio_timer <= 0.0):
				_walk_audio_timer = _walk_audio_timer_duration
				walk_audio_stream_player.stream = walk_sfxs[randi() % 4]
				walk_audio_stream_player.play()
		else:
			character_sprite.texture = idle_sprite
			animation_player.current_animation = "idle"
		_handle_walk_audio_timer(delta)
	

func _physics_process(delta):
	if (is_operational):
		if (_jump_input_recieved):
			_jump_input_recieved = false
			velocity.y = -JUMP_SPEED
		velocity.x = horizontal_input_direction * MOVEMENT_SPEED
		if (velocity.y < 500.0):
			velocity.y += Global.get_gravity() * delta
		if (velocity.x != 0.0):
			character_sprite.scale.x = -sign(velocity.x)
		velocity = move_and_slide(velocity, Vector2.UP)
	

func _handle_horizontal_input():
	horizontal_input_direction = 0.0
	if (character_left):
		horizontal_input_direction -= 1.0
		last_horizontal_input_direction = -1.0
	if (character_right):
		horizontal_input_direction += 1.0
		last_horizontal_input_direction = 1.0

func _handle_vertical_input():
	if (character_jump && is_on_floor()):
		_jump_input_recieved = true

func _handle_shoot_input():
	if (character_shoot && _shoot_timer <= 0.0):
		_shoot_timer = _shoot_timer_duration
		var bullet = character_bullet.instance()
		get_tree().get_root().add_child(bullet)
		bullet.position = position
		bullet.velocity = Vector2(last_horizontal_input_direction * bullet.BASE_SPEED, 0)

func _handle_shoot_timer(delta):
	if (_shoot_timer > 0.0):
		_shoot_timer -= delta

func _handle_input():
	character_jump = Input.is_action_just_pressed("character_jump")
	character_left = Input.is_action_pressed("character_left")
	character_down = Input.is_action_pressed("character_down")
	character_right = Input.is_action_pressed("character_right")
	character_shoot = Input.is_action_pressed("character_shoot")
	_handle_horizontal_input()
	_handle_vertical_input()
	_handle_shoot_input()

func _handle_walk_audio_timer(delta):
	if (_walk_audio_timer > 0.0):
		_walk_audio_timer -= delta

func _handle_is_operational_timer(delta):
	if (is_operational_timer > 0.0):
		is_operational_timer -= delta
	else:
		is_operational = true
