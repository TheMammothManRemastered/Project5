extends Node

var level_name = "res://scenes/levels/level_ex.tscn"

var player = null
var curr_level_scene = null
var curr_level_rooms = null
var curr_spawn_ID = -1

func load_level(lname = "res://scenes/levels/level_ex.tscn"):
	print("loading level " + lname + "...")
	curr_spawn_ID = -1
	level_name = lname
	player = load("res://scenes/objects/player.tscn").instantiate()
	curr_level_scene = load(level_name).instantiate()
	curr_level_rooms = curr_level_scene.get_rooms_packed()
	
	get_tree().change_scene_to_file(curr_level_scene.spawn_room)

func change_room_in_level(target_room_ID, target_door_ID):
	print(target_room_ID)
	var next_room = curr_level_rooms[target_room_ID]
	player.get_parent().remove_child(player)
	curr_spawn_ID = target_door_ID
	get_tree().change_scene_to_packed(next_room)

func connect_change_level(rorigin):
	rorigin.change_level.connect(load_level)
	
