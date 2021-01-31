extends Node

var _gravity = 1000.0
var _health = 100
var _max_health = 100
var health_texture_progress
var _hurt_cooldown_timer = 0
var _hurt_cooldown_timer_duration = 1.6

func _process(delta):
	_handle_hurt_cooldown_timer(delta)

func _handle_hurt_cooldown_timer(delta):
	if (_hurt_cooldown_timer > 0.0):
		_hurt_cooldown_timer -= delta

func get_gravity():
	return _gravity

func heal_player(var value):
	_health = min(_health + value, _max_health)
	health_texture_progress = get_tree().get_current_scene().get_node("Camera2D/HealthTextureProgress")
	if (health_texture_progress):
		health_texture_progress.value = _health

func hurt_player(var value):
	if (_hurt_cooldown_timer <= 0.0):
		_health = max(_health - value, 0)
		health_texture_progress = get_tree().get_current_scene().get_node("Camera2D/HealthTextureProgress")
		if (health_texture_progress):
			health_texture_progress.value = _health
	if (_health <= 0.0):
		get_tree().change_scene("res://assets/scenes/main_menu/main_menu.tscn")
		_health = _max_health


func set_health(var value):
	_health = clamp(value, 0, _max_health)
	health_texture_progress = get_tree().get_current_scene().get_node("Camera2D/HealthTextureProgress")
	if (health_texture_progress):
		health_texture_progress.value = _health
