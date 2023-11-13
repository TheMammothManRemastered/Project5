extends Node2D

class_name Room

const ROOM_FILEPATH = "res://scenes/levels/rooms/"

@export var room_name = "roomTemplate.tscn"
@export var room_ID = -1
@export var player_spawn_ID = -1

var registry = null

signal registry_updated(room_ID, registry)

func _ready():
	# read this room's registry entry from the Level (available in Autoload) and load it into the local registry
	apply_registry(LevelManager.curr_level_registries[room_ID])
	
	# spawn the player node from Autoload at the given door at doors[player_spawn_ID]'s ExitPoint
	#	if player_spawn_ID == -1, use this room's PlayerSpawnPoint, or (0, 0) if that does not exist
	player_spawn_ID = LevelManager.curr_spawn_ID
	if (player_spawn_ID == -1):
		LevelManager.player.global_position = $PlayerSpawnPoint.global_position
	else:
		LevelManager.player.global_position = $Doors.get_children()[player_spawn_ID].get_child(0).global_position
	
	self.add_child(LevelManager.player)
	
	connect_to_all_doors()

func connect_to_all_doors():
	for door in $Doors.get_children():
		print("connecting door")
		door.player_entered_door.connect(LevelManager.change_room_in_level)

func build_registry():
	var out = {
		"doors" : [],
		"e_spawners" : [],
		"p_spawners" : [],
		"player_spawn_ID" : player_spawn_ID
	}
	for i in $Doors.get_children():
		var to_add = i.get_registry_entry()
		out["doors"].append(to_add)
	
	return out

func apply_registry(remote_registry):
	if (registry == null):
		registry = build_registry()
	
	player_spawn_ID = remote_registry["player_spawn_ID"]
	for i in range(len(remote_registry["doors"])):
		registry["doors"][i] = remote_registry["doors"][i]
		$Doors.get_children()[i].apply_registry(registry["doors"][i])

func get_scene_name():
	return ROOM_FILEPATH + name + ".tscn"
