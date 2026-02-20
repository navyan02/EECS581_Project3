extends Node2D

@export var next_scene_path = "res://src/Level2/ConnectTheDots.tscn"

func _ready() -> void:
	$AnimationPlayer.play("fadeToNormal")
	$AnimationPlayer.play("rocketGo")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file(next_scene_path)# Replace with function body.
