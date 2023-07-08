extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -460.0
var gravity = 900

func _ready():
	Global.hero = self
	Global.game_over_signal.connect($UI.hide)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
			
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
	$UI/Score.text = "Score: " + str(Global.coin_count)
