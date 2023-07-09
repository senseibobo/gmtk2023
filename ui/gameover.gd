extends CanvasLayer


func _input(event):
	if Input.is_action_just_pressed("restart"):
		get_tree().paused = false
		Global.restart_v = true
		Global.restart()
		queue_free()
	if Input.is_action_just_pressed("mainmenu"):
		get_tree().paused = false
		Global.restart_v = false
		Global.restart()
		queue_free()
	
func _ready():
	$VBoxContainer/Coins.text = "Coins: " + str(Global.coin_count)
	$VBoxContainer/Distance.text = "Distance: " + str(Global.distance).pad_decimals(1)
	$VBoxContainer/LongestDistance.text = "Longest Distance: " + str(max(Global.longest_distance,Global.distance)).pad_decimals(1)
