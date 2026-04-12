extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func check_win():
	var pipes = get_tree().get_nodes_in_group("pipes")
	
	for pipe in pipes:
		if not pipe.correct():
			return false
	win()
	return true
	
func win():
	print("YOU WIN!!! WOOOOO")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
