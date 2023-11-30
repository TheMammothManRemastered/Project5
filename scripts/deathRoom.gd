extends Room

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	LevelManager.player.yp.stop()
	$Doors/Door.target_room_ID = LevelManager.player.crd
