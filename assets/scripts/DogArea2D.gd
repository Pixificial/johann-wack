extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_DogArea2D_body_entered(var body):
	get_tree().change_scene("res://assets/scenes/credits/credits.tscn")
