extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -700.0
var coin_counter: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
			
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY

func pick_up_coin():
	coin_counter += 1
	print("Player has: ", coin_counter, " coins!")
