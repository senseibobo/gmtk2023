extends Area2D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.pick_up_coin()
		queue_free()
