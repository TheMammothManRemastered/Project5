extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Icon.rotation_degrees += 1

func load_test_level():
	get_tree().change_scene_to_file("res://scenes/levels/test_level.tscn")

func load_level_one():
	LevelManager.load_level("res://scenes/levels/levelExample1.tscn")
