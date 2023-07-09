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

const boing_sounds = [
	preload("res://sound/PECURKA/BOING.wav"),
	preload("res://sound/PECURKA/BOING-01.wav"),
	preload("res://sound/PECURKA/BOING-02.wav"),
	preload("res://sound/PECURKA/BOING-03.wav"),
	preload("res://sound/PECURKA/BOING-04.wav"),
	preload("res://sound/PECURKA/BOING-05.wav")
]


func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.play_sound(boing_sounds[randi()%boing_sounds.size()],0.0,-10.0)
		body.jump()
		$AnimationPlayer.play("jump")
