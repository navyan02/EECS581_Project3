extends Area2D

@export var mainLevel : Node

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		mainLevel.interactedWithJailCells = true
		_show_dialog("All of the jail cells are empty... Why isn't my team here?")
		mainLevel.checkForAlien()
	
func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
