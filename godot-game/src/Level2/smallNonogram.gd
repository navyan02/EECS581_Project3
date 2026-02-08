extends Area2D

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	print("inputEvent")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print("Clicked on the object!")
