extends Node2D

var nonogramSolved = false

func _ready() -> void:
	get_node("SmallAccessButtons").play("Access Denied")
	

func _on_nonogram_puzzle_nonogram_solved() -> void:
	nonogramSolved = true
	get_node("SmallAccessButtons").play("Access Granted")
	get_node("SmallGrid/AnimatedSprite2D").visible = true

signal finishLevel2

func _on_door_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if nonogramSolved:
			finishLevel2.emit()
			$Endscene.visible = true
		else:
			print("Access not granted")
