extends Node2D

@onready var dots_node = $Dots
@onready var dots = $Dots.get_children()
@onready var line_drawer = $LineDrawer
@export var snap_distance := 120.0 

var active_dot: Area2D = null
var start_dot: Area2D = null

func _ready():
	# --- Arrange dots in a circle ---
	var count = dots.size()
	
	for dot in dots:
		print(dot.name, " script: ", dot.get_script())

	for dot in dots:
		print(dot.name, " neighbors: ", [dot.neighbors])

	#Automatically assign 2 neighbors (previous and next in circle)
	'''
	for i in range(count):
		var prev_idx = (i - 1 + count) % count
		var next_idx = (i + 1) % count
		dots[i].neighbors = [
			dots_node.get_path_to(dots[prev_idx]),
			dots_node.get_path_to(dots[next_idx])
		]
	'''
	#Connect input signals
	for dot in dots:
		dot.input_event.connect(Callable(self, "_on_dot_input").bind(dot))

func _on_dot_input(viewport, event: InputEvent, shape_idx, dot):
	print("Clicked dot: ", dot.name)
	if event is InputEventMouseButton:
		if event.pressed:
			active_dot = dot
			if start_dot == null:
				start_dot = dot
			line_drawer.start_preview(dot.global_position)
		else:
			attempt_connection(dot)

func attempt_connection(target_dot: Area2D):
	if target_dot == active_dot:
		line_drawer.cancel_preview()
		active_dot = null
		return

	if not is_neighbor(active_dot, target_dot):
		line_drawer.cancel_preview()
		active_dot = null
		return

	line_drawer.finish_preview(target_dot.global_position)
	active_dot.connected = true
	target_dot.connected = true

	if target_dot == start_dot and all_connected():
		success()

	active_dot = target_dot

func is_neighbor(a: Area2D, b: Area2D) -> bool:
	for path in a.neighbors:
		if a.get_node(path) == b:
			return true
	return false

func all_connected() -> bool:
	for dot in dots:
		if not dot.connected:
			return false
	return true

func success():
	print("Puzzle completed!")
