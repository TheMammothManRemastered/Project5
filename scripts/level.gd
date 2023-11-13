extends Node

@export var spawn_room = ""

func build_room_registries():
	var out = []
	for i in $Rooms.get_children():
		out.append(i.build_registry())
	return out

func change_room(target_room_ID, target_door_ID):
	print("hoii!!!")

func get_rooms_packed():
	var out = []
	for i in $Rooms.get_children():
		out.append(load(i.get_scene_name()))
	return out;
