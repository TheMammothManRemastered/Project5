extends CharacterBody2D

const WALK_ACCEL = 60
const WALK_MAX_SPEED = 500
const RUN_ACCEL = 240
const RUN_MAX_SPEED = 1200
const DECEL = 100
const AIR_DECEL = 30
const AIRSTRAFE_ACCEL = 60
const AIRSTRAFE_MAX_SPEED = RUN_MAX_SPEED
const JUMP_VELOCITY = -1200.0
const WALLJUMP_VECTOR = Vector2(800, JUMP_VELOCITY * 0.95)
const MAX_JUMPTIME = 8
const JUMP_GRAVITY_BOOST = 0.5
const JUMP_MOON_GRAVITY = 0.2
const WALL_SLIDE_GRAVITY = 0.5
const WALL_SLIDE_SPEEDCAP = 280
const MAX_JUMPS = 2
const FAST_FALL_FACTOR = 8
const PARRY_SCENE = preload("res://scenes/objects/parry.tscn")
const SWORD_SCENE = preload("res://scenes/objects/sword.tscn")
const PARRY_MULT = 0.1

enum facing_t {
	LEFT = -1,
	RIGHT = 1
}
enum character_action_t {
	IDLE,
	AIRDODGE,
	DASH,
	DASH_END,
	DASH_START,
	JUMP_LAND,
	JUMP_RISE,
	JUMP_APEX,
	JUMP_FALL,
	JUMP_SQUAT,
	WALK
}

var jumptime : int = 0
var air_movement_locked : bool = false
var curr_facing : facing_t = facing_t.RIGHT
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var curr_jumps : int = MAX_JUMPS
var curr_action : character_action_t = character_action_t.IDLE
var is_parrying : bool = false
var use_parry_mult : bool = false
var health : int = 20

# constant 60 fps call rate, delta is constant
func _physics_process(delta):
	var x_axis = Input.get_axis("player_left", "player_right")
	var y_axis = Input.get_axis("player_up", "player_down")
	var jump_pressed = Input.is_action_just_pressed("player_jump")
	var jump_held = Input.is_action_pressed("player_jump")
	var parry_pressed = Input.is_action_just_pressed("player_parry")
	
	# get facing
	curr_facing = facing_t.RIGHT if x_axis >= 0.1 else curr_facing
	curr_facing = facing_t.LEFT if x_axis <= -0.1 else curr_facing
	
	enhanced_movement(delta, x_axis, y_axis, jump_pressed, jump_held, parry_pressed)
	
	velocity.x *= PARRY_MULT if use_parry_mult else 1
	velocity.y *= PARRY_MULT if use_parry_mult else 1
	
	if (parry_pressed):
		try_parry()
	
	move_and_slide()

# attempts to spawn a parry if possible
func try_parry():
	if is_parrying:
		return
	if ($ParrySpawn.position.x > 0 and curr_facing == facing_t.LEFT) or ($ParrySpawn.position.x < 0 and curr_facing == facing_t.RIGHT):
		$ParrySpawn.position.x *= -1
	var parry = PARRY_SCENE.instantiate()
	$ParrySpawn.add_child(parry)
	parry.parry_despawn.connect(_on_parry_despawn)
	parry.parry_inactive.connect(_on_parry_inactive)
	parry.melee_blocked.connect(_on_melee_parried)
	parry.bullet_blocked.connect(_on_bullet_parried)
	is_parrying = true
	use_parry_mult = true

func _on_parry_despawn():
	is_parrying = false

func _on_parry_inactive():
	use_parry_mult = false

func _on_melee_parried(melee):
	pass

func _on_bullet_parried(bullet):
	bullet.parried()

func _on_hit_by_bullet(damage, bvelocity, bposition):
	health -= damage
	# do knockback here if in the air

# main movement processor
func enhanced_movement(delta, x_axis : float, y_axis : float, jump_pressed : bool, jump_held : bool, parry_pressed : bool):
	# process base movement
	var gravity_factor = 1
	if (is_on_floor()):
		air_movement_locked = false
		curr_jumps = MAX_JUMPS
		jumptime = 0
		em_grounded_movement(x_axis)
	else:
		gravity_factor = em_air_movement(x_axis, y_axis)
	
	# process walljump
	if (is_on_wall_via_raycast(true) and jump_pressed and is_facing_into_colliding_wall(x_axis)):
		em_walljump()
		air_movement_locked = true
	
	# process jumping and double jumping
	if (curr_jumps > 0 and not air_movement_locked):
		if (jump_pressed):
			em_jump()
	if (is_in_air() and not air_movement_locked):
		if (jump_held):
			jumptime += 1
		else:
			jumptime = MAX_JUMPTIME + 1
		gravity_factor = gravity_factor + JUMP_GRAVITY_BOOST if jumptime > MAX_JUMPTIME else JUMP_MOON_GRAVITY
	
	# process wall sliding
	if (is_on_wall_via_raycast() and velocity.y > 0 and is_facing_into_colliding_wall(x_axis)):
		gravity_factor = WALL_SLIDE_GRAVITY
	
	# apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta * gravity_factor
	if (is_on_wall_via_raycast() and velocity.y > WALL_SLIDE_SPEEDCAP and is_facing_into_colliding_wall(x_axis)):
		velocity.y = WALL_SLIDE_SPEEDCAP

# horizontal movement on the ground
func em_grounded_movement(x_axis : float):
	const DASH_THRESH = 0.8
	const DEADZONE = 0.1
	var accel = WALK_ACCEL
	var cap = WALK_MAX_SPEED
	
	# if above dash_thresh, use the run acceleration, otherwise use walk
	# if not moving at all, tend down towards the zero vector by decel
	
	if (absf(x_axis) > DASH_THRESH):
		accel = RUN_ACCEL
		cap = RUN_MAX_SPEED
	elif (absf(x_axis) < DEADZONE):
		velocity = velocity.move_toward(Vector2.ZERO, DECEL)
		return
	
	velocity.x += accel * curr_facing
	if (absf(velocity.x) > cap):
		velocity.x = cap * curr_facing

# horizontal movement in the air and fastfall. returns a number to be used as a gravity multiplier
func em_air_movement(x_axis : float, y_axis : float):
	# move horizontally as usual
	# if the y axis is above the threshold, return a multiplier to be used for fastfall
	const FASTFALL_THRESH = 0.8
	const DEADZONE = 0.1
	var accel = AIRSTRAFE_ACCEL
	var cap = AIRSTRAFE_MAX_SPEED
	
	if (absf(x_axis) > DEADZONE and not air_movement_locked):
		velocity.x += accel * curr_facing
		if (absf(velocity.x) > cap):
			velocity.x = cap * curr_facing
	elif (not air_movement_locked):
		velocity.x = velocity.move_toward(Vector2.ZERO, AIR_DECEL).x
	
	if (y_axis > FASTFALL_THRESH):
		return FAST_FALL_FACTOR
	return 1

# jump and double jump
func em_jump():
	jumptime = 0
	curr_jumps -= 1
	
	velocity.y = JUMP_VELOCITY

# uses the player scene's raycasts to emulate is_on_wall and is_only_on_wall
func is_on_wall_via_raycast(only_wall = false):
	# this is necessary at all bc we can bounce off the wall for like a frame
	# this is enough to make is_on_wall fail
	var on_wall = false
	if $LeftWallCast.is_colliding():
		on_wall = true
	elif $RightWallCast.is_colliding():
		on_wall = true
	if (is_on_ceiling() or is_on_floor()):
		on_wall = false
	else:
		return on_wall

# used in walljumping
func is_facing_into_colliding_wall(x_axis):
	if (not is_on_wall_via_raycast()):
		return false
	var wall_direction = facing_t.LEFT if $RightWallCast.is_colliding() else facing_t.RIGHT
	return wall_direction != curr_facing and x_axis != 0

# walljump processing
func em_walljump():
	velocity = WALLJUMP_VECTOR
	velocity.x *= -1 * curr_facing

func is_in_air():
	return not (is_on_floor() or is_on_wall())
