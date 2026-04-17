extends Area2D

@export var base_connections = []
var connections = []

@export var correctRotation := 0
var curRotation := 0 

func _ready():
	# Save correct rotation (from editor)
	
	correctRotation = int(abs(round(rotation_degrees / 90))) % 4
	
	# Start from base connections
	connections = base_connections.duplicate()
	
	# Scramble
	randomize()
	curRotation = randi() % 4
	rotation_degrees = curRotation * 90
	
	# Apply rotation to connections
	for i in range(curRotation):
		connections = rotate1Time(connections)
	
	updateVisual()

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		rotatePipe()


func correct():
	return curRotation == correctRotation


func updateVisual():
	if correct():
		$line.modulate = Color(0, 1, 0) # green
	else:
		$line.modulate = Color(18.892, 18.892, 18.892)


func rotatePipe():
	curRotation = (curRotation + 1) % 4
	rotation_degrees = curRotation * 90
	
	connections = rotate1Time(connections)
	
	updateVisual()
	
	get_tree().get_root().get_node("Pipes").check_win()


func rotate1Time(dirs):
	var order = ["up", "right", "down", "left"]
	var newDirs = []
	
	for d in dirs:
		var idx = order.find(d)
		newDirs.append(order[(idx + 1) % 4])
	
	return newDirs
