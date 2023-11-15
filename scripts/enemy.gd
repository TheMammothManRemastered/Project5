extends CharacterBody2D

class_name Enemy

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal on_die

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
