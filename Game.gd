extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = randi()%4+8
var water_width: int = 3
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 3
var coins_spawned_counter: int = 0
var next_coin: int = 10
var block_spacing: float = 100.0

func _ready():
	move_step = 1600

func _process(delta):
	
	if Input.is_action_pressed("select_regular_platform"): #d
		current_platform_selected = 0
		$ColorRect.set_size(Vector2(300,50))
	elif Input.is_action_pressed("select_jump_platform"): #s
		current_platform_selected = 1
		$ColorRect.set_size(Vector2(50,30)) # idk why this works
	
	if current_platform_selected == 0:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -150+get_global_mouse_position().x
		$ColorRect.global_position.y = int(get_global_mouse_position().y-25)/25*25
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
	elif current_platform_selected == 1:
		var offset = fmod($Moving.global_position.x,100)
		$ColorRect.global_position.x = -25+get_global_mouse_position().x
		$ColorRect.global_position.y = int(get_global_mouse_position().y)/25*25
		if Input.is_action_just_released("place_platform"):
			var platform = preload("res://Jump Platform.tscn").instantiate()
			$Moving.add_child(platform)
			platform.global_position = $ColorRect.global_position
		
	$Moving.global_position.x -= delta*speed
	move_step += delta*speed
	while move_step >= 100:
		spawn_block()
		
	for child in $Moving.get_children():
		if child.global_position.x < -600:
			child.queue_free()
		
func spawn_block():
	var block
	water_counter += 1
	move_step -= block_spacing
	if water_counter > next_water:
		if water_counter == next_water + 1:
			water_width = 2+randi()%2
		block = preload("res://Water.tscn").instantiate()
		#VODU DA URADIM
		water_width -= 1
		if water_width == 0:
			water_counter = 0
			next_water = 7+randi()%3
	else:
		block = preload("res://grass.tscn").instantiate()
	$Moving.add_child(block)
	block.global_position.x = 1300-move_step
	block.global_position.y = 500
	next_coin -= 1
	if next_coin == 0:
		spawn_coin(1300-move_step-block_spacing/2)
		next_coin = 10+randi()%10
		
func spawn_coin(x_position: float):
	var coin = preload("res://coin.tscn").instantiate()
	$Moving.add_child(coin)
	coin.global_position = Vector2(x_position,randf_range(10,450))
	coins_spawned_counter += 1
	print("Coin Spawned!")
	return coin
