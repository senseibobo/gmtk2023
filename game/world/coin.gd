extends Area2D

const coin_sounds = [
#	preload("res://sound/COIN/coin sakupljanje-01.wav"),
#	preload("res://sound/COIN/coin sakupljanje-02.wav"),
#	preload("res://sound/COIN/coin sakupljanje-03.wav"),
#	preload("res://sound/COIN/coin sakupljanje-04.wav"),
#	preload("res://sound/COIN/coin sakupljanje-05.wav"),
	preload("res://sound/COIN/coin sakupljanje.wav")
]

func _on_body_entered(body):
	if body.is_in_group("Player"):
		Global.play_sound(coin_sounds[randi()%coin_sounds.size()],0.5,-0.9)
		body.pick_up_coin()
		queue_free()
