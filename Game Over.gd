extends Area2D


func _on_body_entered(body):
	var gameover = preload("res://gameover.tscn").instantiate()
	get_tree().root.add_child(gameover)
	get_tree().paused = true
