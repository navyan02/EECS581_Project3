extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("fadeToNormal")
	$AnimationPlayer.play("rocketGo")
