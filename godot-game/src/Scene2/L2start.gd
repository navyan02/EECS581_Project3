#extends Node2D
#
#func _ready():
	#$AnimationPlayer.play("fadeToBlack")
#
#func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#if anim_name == "fadeToBlack":
		#$AnimationPlayer.play("fadeToNormal")

extends Node2D

@export var next_scene_path := "res://src/Scene2/TakeoffScene.tscn"

func _ready() -> void:
	$AnimationPlayer.play("fadeToBlack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeToBlack":
		get_tree().change_scene_to_file(next_scene_path)
