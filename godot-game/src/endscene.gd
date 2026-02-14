extends Node2D

@export var next_scene_path = "res://src/Scene2/TakeoffScene.tscn"

func _ready() -> void:
	$AnimationPlayer.play("fade")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade":
		get_tree().change_scene_to_file(next_scene_path)# Replace with function body.
