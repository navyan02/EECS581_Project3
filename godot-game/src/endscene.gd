extends Node2D

# Change to be the initial scene for level 3
#@export var next_scene_path = "res://src/Scene2/TakeoffScene.tscn"

func _on_spaceship_door_finish_level_2() -> void:
		$AnimationPlayer.play("fade")

# When we finish level 3, uncomment this code
#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "fade":
#		Wait for a bit so the player can see the endscene before switching to the next level
		#await get_tree().create_timer(1).timeout
		#get_tree().change_scene_to_file(next_scene_path)
