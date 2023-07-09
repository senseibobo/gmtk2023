extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -460.0
var gravity = 900

func _ready():
	Global.hero = self

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
