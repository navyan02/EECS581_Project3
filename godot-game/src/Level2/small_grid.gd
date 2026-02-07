extends Area2D
class_name SmallGrid

@export var nonogramPuzzle : Node

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)
	print("Script attached")

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	print("input")
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		nonogramPuzzle.visible = true
		print("I've been clicked!")
