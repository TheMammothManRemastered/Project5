extends Node2D

@export var locked = false
@export var target_room_ID = -1
@export var target_door_ID = -1
@export var exit_rotation = 0

signal player_entered_door(target_room_ID, target_door_ID)

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: easily customizable door exit points
	#$ExitPoint.rotation_degrees = exit_rotation
	pass

func _on_area_2d_body_entered(body):
	print("body enetered")
	if (body.name == "Player"):
		player_entered_door.emit(target_room_ID, target_door_ID)

func get_registry_entry():
	var out = {
		"locked" : locked,
		"target_room_ID" : target_room_ID,
		"target_door_ID" : target_door_ID
	}
	return out

func apply_registry(r_entry):
	locked = r_entry["locked"]
	target_room_ID = r_entry["target_room_ID"]
	target_door_ID = r_entry["target_door_ID"]
