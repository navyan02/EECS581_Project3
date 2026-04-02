extends Node2D

@export var interactedWithJailCells = false
@export var interactedWithHologram = false

func checkForAlien():
	if interactedWithHologram and interactedWithJailCells:
		print("enter alien")
		$AlienAnim.play("Alien Catches Intern")
	else:
		print("missing interaction")
