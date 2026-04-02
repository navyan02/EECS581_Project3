extends Node2D

@export var interactedWithJailCells = false
@export var interactedWithHologram = false

func checkForAlien():
	if interactedWithHologram and interactedWithJailCells:
		print("enter alien")
	else:
		print("missing interaction")
