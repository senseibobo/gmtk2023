extends Area2D

const scythe_sounds = [
	preload("res://sound/SWING/SWING-01.wav"),
	preload("res://sound/SWING/SWING-02.wav"),
	preload("res://sound/SWING/SWING-03.wav"),
	preload("res://sound/SWING/SWING-04.wav"),
	preload("res://sound/SWING/SWING.wav")
]

func _on_body_entered(body):
	Global.death()
	Global.play_sound(scythe_sounds[randi()%scythe_sounds.size()],0.6)
