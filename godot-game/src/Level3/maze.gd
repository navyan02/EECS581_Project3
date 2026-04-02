extends Area2D

var clickedBefore = false

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		if clickedBefore:
			get_tree().change_scene_to_file("res://src/Level3/PacManGame.tscn")
		else:
			_show_dialog("I bet I can use this map to find where they're keeping my team!")
			clickedBefore = true
			
func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
