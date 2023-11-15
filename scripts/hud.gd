extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "Currently Facing: " + ("LEFT" if (LevelManager.player.curr_facing == -1) else "RIGHT")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "Currently Facing: " + ("LEFT" if (LevelManager.player.curr_facing == -1) else "RIGHT")
	$Label2.text = "Parry Charged: " + ("NO" if LevelManager.player.is_parrying else "YES")
	$Label4.text = "Health :" + str(LevelManager.player.health)
