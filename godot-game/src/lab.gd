extends Node

@export var next_scene_path = "res://src/Scene2/TakeoffScene.tscn"

var hand_cursor = preload("res://assets/ui/cursorActiveSmall.png")

func change_cursor_hand():
	Input.set_custom_mouse_cursor(hand_cursor)
	
func change_cursor_back():
	Input.set_custom_mouse_cursor(null)
	
# The notepad was opened so lets wait a few seconds then fade in the you win screen
func _on_locked_computer_screen_notepad_was_opened() -> void:
	await get_tree().create_timer(7.0).timeout
	get_tree().change_scene_to_file(next_scene_path)# Replace with function body.
