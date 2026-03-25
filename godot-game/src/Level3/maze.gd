extends Area2D

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		get_tree().change_scene_to_file("res://src/Level3/PacManGame.tscn")
