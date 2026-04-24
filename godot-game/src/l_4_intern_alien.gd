extends Node2D

var completedDialog = false
var pickedUpTranslatorTablet = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if completedDialog and not pickedUpTranslatorTablet:
			_show_dialog("Kevin: WAIT! You'll need a way to understand our language. Luckily English words have a 1-to-1 correspondance with Alienese words!")
			await get_tree().create_timer(5).timeout
			_show_dialog("Kevin: You just need to convert the alphabet. Let me write the translation down real quick.")
			await get_tree().create_timer(4).timeout
			_show_dialog("...")
			await get_tree().create_timer(1.5).timeout
			_show_dialog("Kevin: Perfect, here you go. I think you'll find it quite useful!")
			if $TranslatorTablet:
				$TranslatorTablet.visible = true
			
		if completedDialog and pickedUpTranslatorTablet:
			_show_dialog("Intern: Thank you for everything, Kevin. It was nice meeting you.")
			await get_tree().create_timer(3.5).timeout
			_show_dialog("Kevin: Of course! I hope to see you again sometime in better circumstances...")
			await get_tree().create_timer(3.5).timeout
			
			get_tree().change_scene_to_file("res://src/Level 4/pipes.tscn")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)


func _on_intern_alien_chat_animation_finished(anim_name: StringName) -> void:
	if anim_name == "alienInternConvo":
		completedDialog = true


func _on_translator_tablet_clicked(item: WorldItem) -> void:
	pickedUpTranslatorTablet = true
