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
	if (not locked and body.name == "Player"):
		player_entered_door.emit(target_room_ID, target_door_ID)
