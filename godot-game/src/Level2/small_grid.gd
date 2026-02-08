extends Area2D
class_name SmallGrid

@export var nonogramPuzzle : Node

var nonogram_is_solved = false

func _ready():
	input_event.connect(_on_input_event)
	set_pickable(true)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if not nonogram_is_solved:
			nonogramPuzzle.visible = true
		else:
			print("The door code has solved. It looks like a rocket")

func _on_nonogram_puzzle_nonogram_solved() -> void:
	nonogram_is_solved = true
