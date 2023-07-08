extends Node

signal game_over_signal

var coin_count: int = 0
var hero: CharacterBody2D

func death():
	game_over_signal.emit()
	var gameover = preload("res://ui/gameover.tscn").instantiate()
	get_tree().root.add_child(gameover)
	get_tree().paused = true
	
func restart():
	coin_count = 0
	get_tree().reload_current_scene()
