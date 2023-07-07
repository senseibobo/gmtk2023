extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = 8
var water_width: int = 3

func _ready():
	move_step = 1300
	Engine.time_scale *= 5

func _process(delta):
	var offset = fmod($Moving.global_position.x,100)
	$ColorRect.global_position.x = -150+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
	$ColorRect.global_position.y = int(get_global_mouse_position().y-25)/50*50
	if Input.is_action_just_released("place_platform"):
		var platform = preload("res://Platform.tscn").instantiate()
		$Moving.add_child(platform)
		platform.global_position = $ColorRect.global_position
		
	$Moving.global_position.x -= delta*speed
	move_step += delta*speed
	while move_step >= 100:
		water_counter += 1
		move_step -= 100
		if water_counter > next_water:
			if water_counter == next_water + 1:
				water_width = 2+randi()%2
			var water = preload("res://grass.tscn").instantiate()
			$Moving.add_child(water)
			water.get_node("ColorRect").color = Color.BLUE
			water.get_node("CollisionShape2D").queue_free()
			water.global_position.x = 1300-move_step
			water.global_position.y = 500
			water_width -= 1
			if water_width == 0:
				water_counter = 0
				next_water = 7+randi()%3
		else:
			var grass = preload("res://grass.tscn").instantiate()
			$Moving.add_child(grass)
			grass.global_position.x = 1300-move_step
			grass.global_position.y = 500
				
	for child in $Moving.get_children():
		if child.global_position.x < -900:
			child.queue_free()
