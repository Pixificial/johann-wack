extends Sprite

var state = 0

var wait_timer = 1.0
var run_timer = 3.0

func _on_Area2D_body_entered(body):
	state = 1
	scale.x = -1.0

func _process(delta):
	if (state == 1):
		if (wait_timer > 0.0):
			wait_timer -= delta
		else:
			state = 2
			scale.x = 1.0
	elif (state == 2):
		if (run_timer > 0.0):
			run_timer -= delta
			position.x += 300.0 * delta
		else:
			queue_free()
