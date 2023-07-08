extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = randi()%4+15
var water_width: int = 3
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 3
var coins_spawned_counter: int = 0
var next_coin: int = 10
var block_spacing: float = 60
var place_platform_size: Vector2 = Vector2(128,22)

func _ready():
	move_step = 1600
	#Engine.time_scale = 2

func _process(delta):
	
	if Input.is_action_pressed("select_regular_platform"): #d
		current_platform_selected = 0
		place_platform_size = Vector2(128,22) 
	elif Input.is_action_pressed("select_jump_platform"): #s
		current_platform_selected = 1
		place_platform_size = Vector2(64,22) 
	var y2 = int(place_platform_size.y)
	$ColorRect.set_size(place_platform_size)
	$ColorRect.global_position = get_global_mouse_position()
	$ColorRect.global_position.y = int(get_global_mouse_position().y)/y2*y2
	$ColorRect.global_position.x -= place_platform_size.x/2.0
	var rect: Rect2 = $ColorRect.get_global_rect()
	var valid = true
	for p in 4:
		var ox = (p%2)*32-16
		var oy = (p/2)*32-32
		if rect.has_point(Global.hero.global_position+Vector2(ox,oy)):
			valid = false
			break
	$ColorRect.color = Color.WHITE if valid else Color.RED
	if valid and Input.is_action_just_pressed("place_platform"):
		var platform
		if current_platform_selected == 0: platform = preload("res://game/platforms/Platform.tscn").instantiate()
		elif current_platform_selected == 1: platform = preload("res://game/platforms/Jump Platform.tscn").instantiate()
		
		$Moving.add_child(platform)
		platform.global_position = $ColorRect.global_position
	$Moving.global_position.x -= delta*speed
	move_step += delta*speed
	while move_step >= block_spacing:
		spawn_block()
		move_step -= block_spacing
		
	for child in $Moving.get_children():
		if child.global_position.x < -600:
			child.queue_free()
		
func spawn_block():
	var block
	water_counter += 1
	if water_counter > next_water:
		if water_counter == next_water + 1:
			water_width = 2+randi()%2
		block = preload("res://game/world/Water.tscn").instantiate()
		water_width -= 1
		if water_width == 0:
			water_counter = 0
			next_water = 7+randi()%3
	else:
		block = preload("res://game/world/grass.tscn").instantiate()
	$Moving.add_child(block)
	block.global_position.x = 1300-move_step
	block.global_position.y = 286
	next_coin -= 1
	if next_coin <= 0:
		spawn_coin(1300-move_step-block_spacing/2)
		next_coin = 10+randi()%10
		
func spawn_coin(x_position: float):
	var coin = preload("res://game/world/coin.tscn").instantiate()
	$Moving.add_child(coin)
	coin.global_position = Vector2(x_position,randf_range(20,300))
	coins_spawned_counter += 1
	print("Coin Spawned!")
	return coin
