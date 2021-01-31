extends Area2D

onready var boss_theme = preload("res://assets/soundtrack/boss.wav")

var music_stream_player

func _ready():
	music_stream_player = get_tree().get_current_scene().get_node("MusicStreamPlayer")

func _on_MusicArea2D_body_entered(body):
	music_stream_player.stream = boss_theme
	music_stream_player.play()
