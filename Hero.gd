extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var coin_counter: int = 0
var gravity = 900

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
	tween.tween_callback(self.death)

func death():
	var gameover = preload("res://gameover.tscn").instantiate()
	get_tree().root.add_child(gameover)
	get_tree().paused = true

func pick_up_coin():
	coin_counter += 1
	print("Player has: ", coin_counter, " coins!")
