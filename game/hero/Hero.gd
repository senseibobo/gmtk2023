extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -460.0
const wood_sounds = [
	preload("res://sound/footsteps wood/footsteps wood 1.wav"),
	preload("res://sound/footsteps wood/footsteps wood 2.wav"),
	preload("res://sound/footsteps wood/footsteps wood 3.wav"),
	preload("res://sound/footsteps wood/footsteps wood 4.wav"),
	preload("res://sound/footsteps wood/footsteps wood 5.wav")]
const grass_sounds = [
	preload("res://sound/footsteps grass/fts grass-01.wav"),
	preload("res://sound/footsteps grass/fts grass-02.wav"),
	preload("res://sound/footsteps grass/fts grass-03.wav"),
	preload("res://sound/footsteps grass/fts grass-04.wav"),
	preload("res://sound/footsteps grass/fts grass-05.wav"),
	preload("res://sound/footsteps grass/fts grass-06.wav"),
	preload("res://sound/footsteps grass/fts grass-07.wav"),
	preload("res://sound/footsteps grass/fts grass-08.wav"),
	preload("res://sound/footsteps grass/fts grass-09.wav"),
	preload("res://sound/footsteps grass/fts grass-10.wav"),
	preload("res://sound/footsteps grass/fts grass-11.wav"),
	preload("res://sound/footsteps grass/fts grass-12.wav")
]
var gravity = 900
var timer: Timer = Timer.new()

func _ready():
	add_child(timer)
	timer.start(0.5)
	timer.timeout.connect(footstep)
	Global.hero = self
	Global.game_started_signal.connect(start)

func start():
	$AnimatedSprite2D.play("default")
	
func footstep():
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("Wood"):
			Global.play_sound(wood_sounds[randi()%wood_sounds.size()],0,-2.0)
		else:
			Global.play_sound(grass_sounds[randi()%grass_sounds.size()],0,4.0)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
			
	if global_position.x < 160:
		velocity.x = 30
	else: velocity.x = 0
	move_and_slide()

const jump_sounds = [
	preload("res://sound/VOICE/jump-01.wav"),
	preload("res://sound/VOICE/jump.wav")
]

func jump():
	velocity.y = JUMP_VELOCITY
	Global.play_sound(jump_sounds[randi()%jump_sounds.size()],0.0,-5.0)

const water_sounds = [
	preload("res://sound/Water/fts water 01.wav"),
	preload("res://sound/Water/fts water 02.wav"),
	preload("res://sound/Water/fts water 03.wav")
]

func drown():
	Global.play_sound(water_sounds[randi()%water_sounds.size()],0.0,1.0)
	var tween = create_tween()
	gravity = 0
	tween.tween_property(self,"velocity:y",0.0,0.5)
	tween.tween_callback(Global.death)

func pick_up_coin():
	Global.coin_count += 1
