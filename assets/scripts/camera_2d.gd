extends Camera2D

var character
var parallax_background

func _ready():
	character = get_parent().get_node("CharacterKinematicBody2D")
	parallax_background = get_child(0)

func _physics_process(delta):
	if (character.position.x > position.x):
		position.x = character.position.x
	elif (character.position.x < position.x - 160.0):
		position.x = character.position.x + 160.0
	if (character.position.y < position.y):
		position.y = character.position.y
	elif (character.position.y > position.y + 110.0):
		position.y = character.position.y - 110.0
	parallax_background.get_child(1).position.x = -fmod(position.x/16.0, 640.0)
	parallax_background.get_child(2).position.x = -fmod(position.x/7.0, 640.0)
	parallax_background.get_child(3).position.x = -fmod(position.x/2.5, 640.0)
