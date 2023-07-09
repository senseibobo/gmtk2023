extends Node2D

var active: bool = false
@export var speed: float = 100.0
var time: float = 10
var move_step: float = 0.0
var water_counter: int = 0
var next_water: int = randi()%4+15
var water_width: int = 6
var current_platform_selected: int = 0 # 0 - regular platform | 1 - jumping platform
var next_coin: int = 20
var next_enemy: int = 3#0
var block_spacing: float = 63.5
var place_platform_size: Vector2 = Vector2(128,22)

func start_game():
	Global.coin_count = 0
	Global.distance = 0
	active = true
	Global.game_started_signal.emit()
	$Menu.hide()
	$HUD.show()

func get_all_buttons(node: Node):
	var buttons = []
	for child in node.get_children():
		if child is Button:
			buttons.append(child)
		buttons.append_array(get_all_buttons(child))
	return buttons

const button_press_sounds = [
	preload("res://sound/BEEPS/BEEPS-01.wav"),
	preload("res://sound/BEEPS/BEEPS-02.wav"),
	preload("res://sound/BEEPS/BEEPS-03.wav"),
	preload("res://sound/BEEPS/BEEPS-04.wav"),
	preload("res://sound/BEEPS/BEEPS-05.wav"),
	preload("res://sound/BEEPS/BEEPS.wav")
]

const button_hover_sounds = [
	preload("res://sound/CLIKS/CLIKS-01.wav"),
	preload("res://sound/CLIKS/CLIKS-02.wav"),
	preload("res://sound/CLIKS/CLIKS-03.wav")
]

func button_hovered():
	Global.play_sound(button_hover_sounds[randi()%button_hover_sounds.size()])
func button_pressed():
	Global.play_sound(button_press_sounds[randi()%button_press_sounds.size()])

const item_distances = [30,60,90,120,150]
const item_costs = [10,20,30,40,50]

const cash_sounds = [
	preload("res://sound/CASH REGISTER/CASH REGISTER-01.wav"),
	preload("res://sound/CASH REGISTER/CASH REGISTER-02.wav"),
	preload("res://sound/CASH REGISTER/CASH REGISTER.wav"),
]

func item_pressed(index: int):
	print("pressed " + str(index))
	if item_costs[index] <= Global.wallet:
		Global.play_sound(cash_sounds[randi()%cash_sounds.size()])
		Global.wallet -= item_costs[index]
		update_stats()
		Global.purchase_item(index)
		Global.save_game()
		init_buttons()

func update_stats():
	$Menu/VBoxContainer/Coins.text = str(Global.wallet)
	$Menu/VBoxContainer/MaxDistance.text = str(Global.longest_distance).pad_decimals(1) + "m"
	$HUD/VBoxContainer/Coins.text = str(Global.coin_count)
	$HUD/VBoxContainer/Distance.text = str(Global.distance).pad_decimals(1) + "m"

func init_buttons():
	await get_tree().create_timer(0.2).timeout
	print(Global.purchased_items)
	var i = 0
	for item in $Menu/ShopMenu/Items.get_children():
		item.get_node("Control/Label").text = "Unlocks\nat " + str(item_distances[i]) + "m"
		item.get_node("Control/Label2").text = str(item_costs[i]) + " coins"
		var arr = []
		for x in Global.purchased_items:
			arr.append(int(x))
		item.get_node("Control/Lock/Sprite2D").texture = preload("res://ui/lock.png")
		if i in arr:
			item.get_node("Control/Lock/Sprite2D").texture = preload("res://ui/check.png")
			item.disabled = true
			item.get_node("Control/Lock").show()
		elif item_distances[i] < Global.longest_distance:
			item.get_node("Control/Lock").hide()
			item.disabled = false
		else:
			item.get_node("Control/Lock").show()
			item.disabled = true
		i += 1


func _ready():
	var i = 0
	for item in $Menu/ShopMenu/Items.get_children():
		item.pressed.connect(item_pressed.bind(i))
		i += 1
	init_buttons.call_deferred()
	for button in get_all_buttons(self):
		button.mouse_entered.connect(self.button_hovered)
		button.pressed.connect(self.button_pressed)
	Global.play_sound(preload("res://sound/AMBIENCE.wav"),0.0,-8,2)
	update_stats()
	if Global.restart_v:
		Global.restart_v = false
		start_game()
	move_step = 1600
	set_platform_placement(preload("res://game/platforms/Platform.tscn"))
	generate_world()
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

const platform_sounds = [
	preload("res://sound/PLATFORM FX/1.wav"),
	preload("res://sound/PLATFORM FX/2.wav")
]

func _process(delta):
	if not active: return
	time += delta
	speed = 20+log(time)*40
	var pp = $PlatformPlacement
	pp.global_position = get_global_mouse_position()
	pp.global_position.y = int(pp.global_position.y)/22*22+11
#   if Input.is_action_pressed("select_regular_platform"): #d
#		set_platform_placement(preload("res://game/platforms/Platform.tscn"))
#		current_platform_selected = 0
#		place_platform_size = Vector2(128,22) 
#	elif Input.is_action_pressed("select_jump_platform"): #s
#		set_platform_placement(preload("res://game/platforms/Jump Platform.tscn"))
#		current_platform_selected = 1
#		place_platform_size = Vector2(64,22)
	
	if Input.is_action_just_pressed("select_next_platform"):
		if current_platform_selected == 1:
			set_platform_placement(preload("res://game/platforms/Platform.tscn"))
			current_platform_selected = 0
		elif current_platform_selected == 0:
			set_platform_placement(preload("res://game/platforms/Jump Platform.tscn"))
			current_platform_selected = 1
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
		#Global.play_sound(platform_sounds[randi()%platform_sounds.size()],0.0,-2.0)
		set_platform_placement(platform_scene)
	$Moving.global_position.x -= delta*speed
	$Background.move(delta*speed)
	move_step += delta*speed
	Global.distance += delta*speed/60.0
	generate_world()
	update_stats()
		
	for child in $Moving.get_children():
		if child.global_position.x < -600:
			child.queue_free()

func generate_world():
	while move_step >= block_spacing:
		spawn_block()
		move_step -= block_spacing
	
func check_platform_valid():
	var platform = $PlatformPlacement.get_child(0)
	var space = get_world_2d().direct_space_state
	var collision = platform.get_node_or_null("CollisionShape2D")
	var check1 = true
	var check2 = true
	var check3 = true
	if collision:
		var shape = platform.get_node("CollisionShape2D").shape.duplicate(true)
		var params = PhysicsShapeQueryParameters2D.new()
		shape.extents *= 0.5
		params.shape = shape
		params.transform = platform.get_global_transform().scaled_local(Vector2(0.01,0.70))
		params.collision_mask = 3
		var result = space.intersect_shape(params,1)
		check1 = result.size() == 0
		var shape2 = platform.get_node("CollisionShape2D").shape.duplicate(true)
		var params2 = PhysicsShapeQueryParameters2D.new()
		shape2.extents *= 1
		params2.shape = shape2
		params2.transform = platform.get_global_transform()
		params2.collision_mask = 2
		var result2 = space.intersect_shape(params2,1)
		check3 = result2.size() == 0
	var ground = platform.get_node_or_null("Ground")
	if ground:
		var params2 = PhysicsShapeQueryParameters2D.new()
		var shape2 = ground.shape.duplicate(true)
		params2.shape = shape2
		params2.transform = ground.get_global_transform()
		params2.collision_mask = 1
		var result2 = space.intersect_shape(params2,1)
		check2 = result2.size() != 0
	return check1 and check2 and check3

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
		next_coin = 5+randi()%5 # oba podeli sa 2 ako dupliras skor
	next_enemy -= 1
	if next_enemy <= 0:
		spawn_enemy(1300-move_step-block_spacing/2)
		next_enemy = 9+randi()%9 # oba podeli sa 2 ako dupliras skor
		
func spawn_coin(x_position: float):
	var coin = preload("res://game/world/coin.tscn").instantiate()
	$Moving.add_child(coin)
	coin.global_position = Vector2(x_position,randf_range(20,280))
	print("Coin Spawned!")
	return coin
	
func spawn_enemy(x_position: float):
	var enemy = preload("res://game/world/Enemy.tscn").instantiate()
	$Moving.add_child(enemy)
	enemy.global_position = Vector2(x_position,randf_range(20,280))
	print("Enemy Spawned!")
	return enemy

func _on_quit_pressed():
	get_tree().quit()


func _on_shop_pressed():
	$Menu/MainMenu.hide()
	$Menu/ShopMenu.show()


func _on_back_pressed():
	$Menu/MainMenu.show()
	$Menu/ShopMenu.hide()


func _on_reset_pressed():
	Global.reset_data()
	$Menu/VBoxContainer/Coins.text = "0"
	$Menu/VBoxContainer/MaxDistance.text = "0M"
	update_stats()
	init_buttons()
