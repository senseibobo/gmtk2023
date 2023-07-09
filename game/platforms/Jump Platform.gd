extends Node2D


var mask = 0
var layer = 0

func disable():
#	mask = collision_mask
#	layer = collision_layer
#	collision_mask = 0
#	collision_layer = 0
	$Area2D.set_deferred("monitoring",false)
func enable():
#	collision_mask = mask
#	collision_layer = layer
	$Area2D.set_deferred("monitoring",true)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.jump()
		$AnimationPlayer.play("jump")
