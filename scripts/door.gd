extends Node2D

@export var locked = false
@export var target_room_ID = -1
@export var target_door_ID = -1

signal player_entered_door(target_room_ID, target_door_ID)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
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
