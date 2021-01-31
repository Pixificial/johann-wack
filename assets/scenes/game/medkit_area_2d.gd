extends Area2D

var heal = 30.0

func _on_MedkitArea2D_body_entered(var body):
	if(body.get_name() == "CharacterKinematicBody2D"):
		Global.heal_player(heal)
		queue_free()
