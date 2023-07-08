extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = 8
var water_width: int = 3
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 3
var coins_spawned_counter: int = 0

func _ready():
	move_step = 1300
	coins()
	#Engine.time_scale *= 5

func coins():
	while true:
		spawn_coin(get_coin_spawn_position())
		await get_tree().create_timer(5.0).timeout

func _process(delta):
	
	if Input.is_action_pressed("select_regular_platform"): #d
		current_platform_selected = 0
		$ColorRect.set_size(Vector2(300,50))
	elif Input.is_action_pressed("select_jump_platform"): #s
		current_platform_selected = 1
		$ColorRect.set_size(Vector2(50,30)) # idk why this works
	
	if current_platform_selected == 0:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -150+get_global_mouse_position().x#int(get_global_mouse_position().x+50)/100*100+offset
		$ColorRect.global_position.y = int(get_global_mouse_position().y-25)/25*25
		#var platform = preload("res://Platform.tscn").instantiate()
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
	elif current_platform_selected == 1:
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
				spawn_coin(get_coin_spawn_position())
		else:
			var grass = preload("res://grass.tscn").instantiate()
			$Moving.add_child(grass)
			grass.global_position.x = 1300-move_step
			grass.global_position.y = 500
		
	for child in $Moving.get_children():
		if child.global_position.x < -600:
			child.queue_free()
		
		
func spawn_coin(position_vector: Vector2):
	var coin = preload("res://coin.tscn").instantiate()
	$Moving.add_child(coin)
	coin.global_position.x = position_vector.x
	coin.global_position.y = position_vector.y
	coins_spawned_counter += 1
	print("Coin Spawned!")

func get_coin_spawn_position():
	randomize()
	var x = 1200
	var y_range = Vector2(10, 200)
	if (randi()%4) < 2:
		y_range = Vector2(10, 200)
	else:
		y_range = Vector2(200, 450)
	var random_y =  randi() % int(y_range[1]-y_range[0]) + 1 + y_range[0]
	var random_pos = Vector2(x, random_y)
	return random_pos
