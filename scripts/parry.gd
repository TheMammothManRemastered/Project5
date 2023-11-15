extends Area2D

signal parry_inactive
signal parry_despawn
signal melee_blocked(melee)
signal bullet_blocked(bullet)

func _on_active_timer_timeout():
	$Sprite.queue_free()
	$CollisionShape2D.disabled = true
	parry_inactive.emit()

func _on_despawn_timer_timeout():
	parry_despawn.emit()
	queue_free()

func on_melee_attack(area):
	melee_blocked.emit(area)

func on_bullet(body):
	bullet_blocked.emit(body)
