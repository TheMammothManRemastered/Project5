extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "Currently Facing: " + ("LEFT" if (LevelManager.player.curr_facing == -1) else "RIGHT")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = "Currently Facing: " + ("LEFT" if (LevelManager.player.curr_facing == -1) else "RIGHT")
