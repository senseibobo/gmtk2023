extends Area2D

const scythe_sounds = [
	preload("res://sound/kosenje/Kosenje1.wav"),
	preload("res://sound/kosenje/Kosenje.wav")
]

func _on_body_entered(body):
	$AnimatedSprite2D.play("hit")
	$AnimatedSprite2D.animation_finished.connect($AnimatedSprite2D.play.bind("default"))
	Global.death()
	Global.play_sound(scythe_sounds[randi()%scythe_sounds.size()],0.6)
