extends Area2D

func _on_body_entered(body):
	print(body.name)
	if body.name == "player":
		body.enter_water()


func _on_body_exited(body):
	if body.name == "player":
		body.exit_water()
