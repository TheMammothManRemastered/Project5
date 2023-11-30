extends Area2D

@export var advance_rate = 1
@export var frozen = false
@export var time_to_activation = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActivationTimer.wait_time = time_to_activation
	
	if (not frozen):
		$ActivationTimer.start()
	
	frozen = true

func unfreeze():
	frozen = false

func _physics_process(delta):
	if (frozen):
		return
	position.x = LevelManager.player.position.x
	position.y -= advance_rate

func _on_body_entered(body):
	if body.name == "Player":
		LevelManager.player.vbp.play()
		LevelManager.change_room_in_level(0, 0)

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		unfreeze()
