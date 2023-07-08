extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_coin():
	pass # remove coin from screen

func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.pick_up_coin()
		#Game.coins_spawned_counter -= 1
		queue_free()
	#if body.is_in_group("WorldBorder"):
		#body.coins_spawned_counter -= 1
		#queue_free()
		#print("coins destroyed")
