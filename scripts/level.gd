extends Node

@export var spawn_room = ""

func build_room_registries():
	var out = []
	for i in $Rooms.get_children():
		out.append(i.build_registry())
	return out
