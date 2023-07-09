extends Node

signal game_over_signal
signal game_started_signal

var restart_v: bool = false
var coin_count: int = 0 # in 1 run
var wallet: int = 0 # long run
var distance: float = 0
var longest_distance: float = 0
var hero: CharacterBody2D

func _ready():
	if FileAccess.file_exists("user://save.json"):
		load_game()

func reset_data():
	var file = DirAccess.open("user://")
	file.remove("save.json")

func load_game():
	var string = FileAccess.get_file_as_string("user://save.json")
	var data = JSON.parse_string(string)
	wallet = data["coins"]
	longest_distance = data["distance"]

func save_game():
	var file = FileAccess.open("user://save.json",FileAccess.WRITE)
	var json = JSON.stringify({"coins":wallet,"distance":longest_distance})
	file.store_string(json)
	file.close()


func death():
	game_over_signal.emit()
	var gameover = preload("res://ui/gameover.tscn").instantiate()
	get_tree().root.add_child(gameover)
	end_game()

func end_game():
	longest_distance = max(longest_distance,distance)
	wallet += coin_count
	save_game()
	get_tree().paused = true

func restart():
	coin_count = 0
	get_tree().reload_current_scene()
