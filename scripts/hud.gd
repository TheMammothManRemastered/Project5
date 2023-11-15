extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Container/Stats/Facing.text = "Currently Facing: " + ("LEFT" if (LevelManager.player.curr_facing == -1) else "RIGHT")
	$Container/Stats/Parry.text = "Parry Charged: " + ("NO" if LevelManager.player.is_parrying else "YES")
	$Container/Stats/Health.text = "Health :" + str(LevelManager.player.health)
