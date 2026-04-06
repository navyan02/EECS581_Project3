extends Node2D

#@export var next_scene_path = ""

func _on_spaceship_door_finish_level_2() -> void:
	$AnimationPlayer.play("fade")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Level3/Level3Start.tscn")
