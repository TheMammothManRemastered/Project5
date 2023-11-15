extends Enemy

const VEL_MULT = 20

var phase = 0
var player = null
var bullet_packedscene = null

func _ready():
	player = LevelManager.player
	bullet_packedscene = load("res://scenes/objects/enemyBullet.tscn")

func _physics_process(delta):
	phased_hover()
	
	aim_gun()
	
	move_and_slide()

func phased_hover():
	self.velocity.y = cos(float(phase) / 30) * VEL_MULT
	phase += 1
	
	if (float(phase) / 30 >= PI * 2):
		phase = 0

func aim_gun():
	var angle = atan2(player.global_position.y - $GunPivot.global_position.y, player.global_position.x - $GunPivot.global_position.x)
	$GunPivot.rotation = angle

func _on_timer_timeout():
	# shoot
	var bullet = bullet_packedscene.instantiate()
	bullet.global_rotation = $GunPivot.global_rotation
	bullet.global_position = $GunPivot/GunSpawn.global_position
	get_tree().root.add_child(bullet)
	bullet.hit_player.connect(bullet_hit_player)
	bullet.spawner = self

func bullet_hit_player(bvelocity, bposition):
	player._on_hit_by_bullet(1, bvelocity, bposition)

func hit_by_player_bullet(bvelocity, bposition):
	on_die.emit()
	queue_free()
	# spawn a corpse at this position if needed
