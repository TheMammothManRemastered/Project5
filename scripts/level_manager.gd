extends Node

var level_name = "res://scenes/levels/level_ex.tscn"

var player = null
var curr_level_scene = null
var curr_level_rooms = null

func _ready():
	pass

func load_level(lname = "res://scenes/levels/level_ex.tscn"):
	print("loading level " + lname + "...")
	level_name = lname
	player = load("res://scenes/objects/player.tscn").instantiate()
	curr_level_scene = load(level_name).instantiate()
	curr_level_rooms = curr_level_scene.build_room_registries()
	
	get_tree().change_scene_to_file(curr_level_scene.spawn_room)
