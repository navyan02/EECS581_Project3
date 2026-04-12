extends Area2D

var curRotation := 0 

func _ready():
	rotation_degrees = 0
	
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		rotatePipe()
		
func rotatePipe():
	curRotation = (curRotation + 1) % 4
	rotation_degrees = curRotation * 90
