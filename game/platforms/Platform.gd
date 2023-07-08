extends StaticBody2D

var mask = 0
var layer = 0

func disable():
	mask = collision_mask
	layer = collision_layer
	collision_mask = 0
	collision_layer = 0
	$CollisionShape2D.set_deferred("disabled",true)
func enable():
	collision_mask = mask
	collision_layer = layer
	$CollisionShape2D.set_deferred("disabled",false)
