'''
File Name: connect_the_dots.gd
Created: 2/10/2026
Last Updated: 2/16/2026
Description: A connect the dots game where the player draws lines from star to star, making the alien ship appear at the end.
'''

extends Node2D

@onready var dots_node = $Dots
@onready var dots = $Dots.get_children()
@onready var line_drawer = $LineDrawer
@onready var alien_ship = $AlienShip
@onready var console = $Console
@onready var intern = $Intern
@export var snap_distance := 120.0 

var active_dot: Area2D = null
var start_dot: Area2D = null
var connections_made := 1
var waiting_for_ship_click := false

func _ready():
	# --- Arrange dots in a circle ---
	var count = dots.size()
	
	for dot in dots:
		print(dot.name, " script: ", dot.get_script())

	for dot in dots:
		print(dot.name, " neighbors: ", [dot.neighbors])

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
	if waiting_for_ship_click:
		return
	if event is InputEventMouseButton and event.pressed:
		active_dot = dot

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
	connections_made += 1
	active_dot.connected = true
	target_dot.connected = true

	if connections_made == dots.size() + 1:
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
	
func shipInScene():
	var tween = create_tween()
	
	tween.parallel().tween_property(
		$Console,
		"position",
		Vector2(0, 15),
		1.2
	)
	tween.parallel().tween_property(
		$Console,
		"scale",
		Vector2(0.86, 0.86),
		1.2
	)
	
	tween.parallel().tween_property(
		$Intern,
		"position",
		Vector2(-100, 75),
		1.2
	)
	tween.parallel().tween_property(
		$Intern,
		"scale",
		Vector2(5, 5),
		1.2
	)

func success():
	
	print("Puzzle completed!")
	alien_ship.visible = true
	alien_ship.modulate.a = 0.0

	var tween = create_tween()
	tween.tween_property(alien_ship, "modulate:a", 1.0, 0.8)
	
	waiting_for_ship_click = true
	$AlienShip.input_pickable = true
	
	await get_tree().create_timer(3.0).timeout
	
	shipInScene()
