extends CanvasLayer

@export var next_scene_path = "res://src/Scene2/TakeoffScene.tscn"

func _on_node_finish_level_1() -> void:
	$AnimationPlayer.play("fade")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(next_scene_path)
