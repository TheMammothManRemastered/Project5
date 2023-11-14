extends Node2D

class_name Room

const ROOM_FILEPATH = "res://scenes/levels/rooms/"

@export var room_name = "roomTemplate.tscn"
@export var room_ID = -1
@export var player_spawn_ID = -1

signal change_level(to)

func _ready():
	# spawn the player node from Autoload at the given door at doors[player_spawn_ID]'s ExitPoint
	#	if player_spawn_ID == -1, use this room's PlayerSpawnPoint, or (0, 0) if that does not exist
	player_spawn_ID = LevelManager.curr_spawn_ID
	if (player_spawn_ID == -1):
		LevelManager.player.global_position = $PlayerSpawnPoint.global_position
	else:
		LevelManager.player.global_position = $Doors.get_children()[player_spawn_ID].get_child(0).global_position
	
	self.add_child(LevelManager.player)
	
	connect_to_all_doors()
	connect_change_level()

func connect_to_all_doors():
	for door in $Doors.get_children():
		print("connecting door")
		door.player_entered_door.connect(LevelManager.change_room_in_level)

func connect_change_level():
	LevelManager.connect_change_level(self)

func get_scene_name():
	var gugga = name
	return ROOM_FILEPATH + name + ".tscn"

func trigger_change_level(body):
	print("trigger hit")
	change_level.emit("res://scenes/levels/levelExample2.tscn");
