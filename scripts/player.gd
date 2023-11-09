extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -1200.0
const WALL_JUMP_VELOCITY = Vector2(900, -1200)
const MAX_JUMPS = 2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 5
var curr_jumps = MAX_JUMPS
var is_wall_jumping = false

func _physics_process(delta):
	var direction = Input.get_axis("player_left", "player_right")
	var is_moving_negative = direction < 0
	
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		curr_jumps = MAX_JUMPS

	# wall jump
	if Input.is_action_just_pressed("player_jump") and is_on_wall_only() and (get_wall_normal().x > 0 == is_moving_negative):
		velocity.y = WALL_JUMP_VELOCITY.y;
		velocity.x = WALL_JUMP_VELOCITY.x * (1 if get_wall_normal().x > 0 else -1);
		is_wall_jumping = true
	# regular jump
	elif Input.is_action_just_pressed("player_jump") and curr_jumps > 0:
		velocity.y = JUMP_VELOCITY
		curr_jumps -= 1
		if is_wall_jumping:
			is_wall_jumping = false

	# horizontal movement
	if not is_wall_jumping:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, (SPEED / 6))
	
	move_and_slide()
	
	# reset wall jumping state if we have collided with something
	if is_wall_jumping:
		if is_on_floor():
			is_wall_jumping = false
