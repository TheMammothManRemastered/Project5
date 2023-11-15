extends CharacterBody2D

const mult = 700

var allegiance_changed = false
var spawner = null

signal hit_player(velocity, position)

func _ready():
	velocity.x = cos(rotation) * mult
	velocity.y = sin(rotation) * mult

func _physics_process(delta):
	move_and_slide()
	if get_slide_collision_count() > 0:
		var die = true
		var p = true
		var h = true
		var a = true
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			if collision.get_collider().name == "Parry" and p:
				die = false
				p = false
			elif collision.get_collider().name == "Player" and h and not allegiance_changed:
				hit_player.emit(velocity, global_position)
				h = false
			elif allegiance_changed and a and collision.get_collider() == spawner:
				spawner.hit_by_player_bullet(velocity, global_position)
				a = false
		if (die):
			queue_free()

func _on_timer_timeout():
	queue_free()

func parried():
	print("parried")
	velocity.x *= -1.5
	velocity.y *= -1.5
	allegiance_changed = true
	becomePlayerBullet()

func becomePlayerBullet():
	# move to layer 10 from layer 17
	# change the mask to no longer affect 9 and 8, and allow affecting 16
	set_collision_layer_value(17, false)
	set_collision_layer_value(10, true)
	
	set_collision_mask_value(8, false)
	set_collision_mask_value(9, false)
	set_collision_mask_value(16, true)

func becomeEnemyBullet():
	# opposite of becomeplayerbullet
	set_collision_layer_value(17, true)
	set_collision_layer_value(10, false)
	
	set_collision_mask_value(8, true)
	set_collision_mask_value(9, true)
	set_collision_mask_value(16, false)
