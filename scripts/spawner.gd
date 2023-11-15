extends Node2D

@export var charges = -1
@export var to_spawn_scenename = ""
@export var allowed_simultaneous_instances = 1
@export var recharge_time = 0

var PACKED_SCENE = "res://scenes/objects/"

# Called when the node enters the scene tree for the first time.
func _ready():
	if (recharge_time != 0):
		$Recharge.wait_time = recharge_time
	else:
		$Recharge.paused = true
	
	PACKED_SCENE += to_spawn_scenename + ".tscn"
	PACKED_SCENE = load(PACKED_SCENE)

# used if the recharge time is 0
func _physics_process(delta):
	if (recharge_time != 0):
		return
	spawn_instance()

# used if the recharge time is non-zero
func _on_recharge_timeout():
	if (recharge_time == 0):
		return
	spawn_instance()

func spawn_instance():
	if (charges == 0):
		return
	
	if (charges != -1):
		charges -= 1
	
	$Recharge.start()
	
	if (allowed_simultaneous_instances <= $InstancePoint.get_child_count()):
		return

	var instanced_scene = PACKED_SCENE.instantiate()
	$InstancePoint.add_child(instanced_scene)

