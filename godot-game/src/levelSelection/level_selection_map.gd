extends Node2D

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://src/OpeningScene/openingscene.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Scene2/TakeoffScene.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://src/Level3/Level3Start.tscn")
