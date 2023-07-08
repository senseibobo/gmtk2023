extends Control


func _input(event):
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		Global.restart()
		queue_free()
	
func _ready():
	$VBoxContainer/Score.text = "Score: " + str(Global.coin_count)
