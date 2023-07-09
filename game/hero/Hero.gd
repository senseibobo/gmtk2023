extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -460.0
const wood_sounds = [
	preload("res://sound/footsteps wood/footsteps wood 1.wav"),
	preload("res://sound/footsteps wood/footsteps wood 2.wav"),
	preload("res://sound/footsteps wood/footsteps wood 3.wav"),
	preload("res://sound/footsteps wood/footsteps wood 4.wav"),
	preload("res://sound/footsteps wood/footsteps wood 5.wav")]
var gravity = 900
var timer: Timer = Timer.new()

func _ready():
	add_child(timer)
	timer.start(0.2)
	timer.timeout.connect(footstep)
	Global.hero = self

func footstep():
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if collider.is_in_group("Wood"):
			Global.play_sound(wood_sounds[randi()%wood_sounds.size()])

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
			
	if global_position.x < 160:
		velocity.x = 30
	else: velocity.x = 0
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY

func drown():
	var tween = create_tween()
	gravity = 0
	tween.tween_property(self,"velocity:y",0.0,0.5)
	tween.tween_callback(Global.death)

func pick_up_coin():
	Global.coin_count += 1
