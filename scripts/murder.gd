extends Area2D

@export var advance_rate = 5
@export var frozen = false
@export var time_to_activation = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$ActivationTimer.wait_time = time_to_activation
	
	if (not frozen):
		$ActivationTimer.start()

func unfreeze():
	frozen = false

func _physics_process(delta):
	if (frozen):
		return
	position.y -= advance_rate
