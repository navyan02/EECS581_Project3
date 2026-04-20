extends Node2D

var gameWon = false

@onready var anim = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func check_win():
	if gameWon:
		return
	
	var pipes = get_tree().get_nodes_in_group("pipes")
	
	for pipe in pipes:
		if not pipe.correct():
			return
	gameWon = true
	win()
	
func win():
	print("YOU WIN!!! WOOOOO")
	$AnimationPlayer.play("flyby")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "flyby":
		get_tree().change_scene_to_file("res://src/Level4/passwordPuzzle.tscn")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
