extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = 8
var water_width: int = 3
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 2
var coins_spawned_counter: int = 0

func _ready():
	move_step = 1300
	#Engine.time_scale *= 3

func _process(delta):
	
	if Input.is_action_pressed("select_regular_platform"): #d
		current_platform_selected = 0
		$ColorRect.set_size(Vector2(300,100))
	else: if Input.is_action_pressed("select_jump_platform"): #s
		current_platform_selected = 1
		$ColorRect.set_size(Vector2(50,60)) # idk why this works
	
	if current_platform_selected == 0:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -150+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
		$ColorRect.global_position.y = int(get_global_mouse_position().y-25)/25*25
		#var platform = preload("res://Platform.tscn").instantiate()
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
	else: if current_platform_selected == 1:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -25+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
		$ColorRect.global_position.y = int(get_global_mouse_position().y)/25*25
		#var platform = preload("res://Jump Platform.tscn").instantiate()
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Jump Platform.tscn").instantiate()
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
				
				
		if coins_spawned_counter < 2:
			pass #spawn_coin(get_coin_spawn_x(), get_coin_spawn_y())
		
	for child in $Moving.get_children():
		if child.global_position.x < -900:
			child.queue_free()
		
func spawn_coin(x: float, y: float):
	var coin = preload("res://grass.tscn").instantiate()
	coin.global_position.x = x
	coin.global_position.y = y
	coins_spawned_counter += 1

func get_coin_spawn_x():
	pass # implement how we get x coordinate for coin spawn, it should be outside of right edge of the screen
	
func get_coin_spawn_y():
	pass # implement how we get y coordinate, for coin spawn, it should be above ground, and snappable to grid
