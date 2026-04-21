extends Node2D

 #Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var inventory = get_tree().get_first_node_in_group("inventory")
	var item_data = $TranslatorTablet.item_data
	if inventory:
		inventory.add_item(item_data)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("I think I can get my team out using my translator! I just need to guess the password...")
		

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)


func _on_boy_3_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("You've GOT to get us out of here!")

func _on_girl_4_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("Please help us escape! They're going to destroy Earth!!!")

func _on_boy_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("I'm Dr. Henry. Nice to meet you, Intern. I wish we were meeting under better circumstances...")
	
func _on_boy_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_show_dialog("I don't know anything about you or how you got here but please help us.")
