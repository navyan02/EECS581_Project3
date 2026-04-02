extends Node2D

@export var next_scene_path := "res://src/Level3/level3.tscn"

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	$AnimationPlayer.play("fadeToBlack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeToBlack":
		get_tree().change_scene_to_file(next_scene_path)
