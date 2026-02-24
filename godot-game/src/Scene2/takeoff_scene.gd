extends Node2D

@export var next_scene_path = "res://src/Level2/ConnectTheDots.tscn"

func _ready() -> void:
	$space/AnimationPlayer.play("level2Intro")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "level2Intro":
		$space/AnimationPlayer.play("rocketGo")
		
	if anim_name == "rocketGo":
		get_tree().change_scene_to_file(next_scene_path)# Replace with function body.
