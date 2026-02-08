extends Node2D

func _ready() -> void:
	get_node("SmallAccessButtons").play("Access Denied")
	

func _on_nonogram_puzzle_nonogram_solved() -> void:
	get_node("SmallAccessButtons").play("Access Granted")
	get_node("SmallGrid/AnimatedSprite2D").visible = true
	pass # Replace with function body.
