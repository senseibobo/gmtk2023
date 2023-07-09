extends Node2D

@export var speed: float = 100.0
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = randi()%4+15
var water_width: int = 6
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var max_coins: int = 3
var coins_spawned_counter: int = 0
var next_coin: int = 10
var block_spacing: float = 63.5
var place_platform_size: Vector2 = Vector2(128,22)

func _ready():
	move_step = 1600
	set_platform_placement(preload("res://game/platforms/Platform.tscn"))
	#Engine.time_scale = 4

var platform_scene

func set_platform_placement(platform_scene):
	self.platform_scene = platform_scene
	var platform = platform_scene.instantiate()
	for child in $PlatformPlacement.get_children():
		$PlatformPlacement.get_child(0).queue_free()
	$PlatformPlacement.add_child(platform)
	platform.disable()
	platform.modulate.a = 0.5

func _process(delta):
	var pp = $PlatformPlacement
	pp.global_position = get_global_mouse_position()
	pp.global_position.y = int(pp.global_position.y)/22*22+11
	if Input.is_action_pressed("select_regular_platform"): #d
		set_platform_placement(preload("res://game/platforms/Platform.tscn"))
		current_platform_selected = 0
		place_platform_size = Vector2(128,22) 
	elif Input.is_action_pressed("select_jump_platform"): #s
		set_platform_placement(preload("res://game/platforms/Jump Platform.tscn"))
		current_platform_selected = 1
		place_platform_size = Vector2(64,22)
	var valid = check_platform_valid()
	$PlatformPlacement.modulate = Color(1.0,int(valid),int(valid),1.0)
	if valid and Input.is_action_just_pressed("place_platform"):
		var platform = $PlatformPlacement.get_child(0)
		var pos = platform.global_position
		$PlatformPlacement.remove_child(platform)
		$Moving.add_child(platform)
		platform.global_position = pos
		platform.modulate.a = 1.0
		platform.enable()
		set_platform_placement(platform_scene)
	$Moving.global_position.x -= delta*speed
	$Background.move(delta*speed)
	move_step += delta*speed
	while move_step >= block_spacing:
		spawn_block()
		move_step -= block_spacing
		
	for child in $Moving.get_children():
		if child.global_position.x < -600:
			child.queue_free()

func check_platform_valid():
	var platform = $PlatformPlacement.get_child(0)
	var space = get_world_2d().direct_space_state
	var collision = platform.get_node_or_null("CollisionShape2D")
	var check1 = true
	var check2 = true
	if collision:
		var shape = platform.get_node("CollisionShape2D").shape.duplicate(true)
		var params = PhysicsShapeQueryParameters2D.new()
		shape.extents *= 0.75
		params.shape = shape
		params.transform = platform.get_global_transform().scaled_local(Vector2(0.70,0.70))
		params.collision_mask = 3
		var result = space.intersect_shape(params,1)
		check1 = result.size() == 0
	var ground = platform.get_node_or_null("Ground")
	if ground:
		var params2 = PhysicsShapeQueryParameters2D.new()
		var shape2 = ground.shape.duplicate(true)
		params2.shape = shape2
		params2.transform = ground.get_global_transform()
		params2.collision_mask = 1
		var result2 = space.intersect_shape(params2,1)
		print(result2)
		check2 = result2.size() != 0
	return check1 and check2

func spawn_block():
	var block
	water_counter += 1
	if water_counter > next_water:
		if water_counter == next_water + 1:
			water_width = 6+randi()%4
		block = preload("res://game/world/Water.tscn").instantiate()
		water_width -= 1
		if water_width == 0:
			water_counter = 0
			next_water = 2+randi()%3
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
