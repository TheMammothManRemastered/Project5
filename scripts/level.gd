extends Node

@export var spawn_room = ""

func change_room(target_room_ID, target_door_ID):
	pass

func get_rooms_packed():
	var out = []
	for i in $Rooms.get_children():
		out.append(load(i.get_scene_name()))
	return out;
