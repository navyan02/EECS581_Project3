extends Node2D

@export var interactedWithJailCells = false
@export var interactedWithHologram = false

func checkForAlien():
	if interactedWithHologram and interactedWithJailCells:
		print("enter alien")
		$AlienAnim.play("Alien Catches Intern")
		var tween = get_tree().create_tween()
		var new_position = Vector2(2523.0, 729.0) # get this from the trigger
		tween.tween_property($Camera2D, "position", new_position, 1)
		tween.tween_property($Camera2D, "position", $Player.position, 0.5)
	else:
		print("missing interaction")
