extends Area2D

signal ship_clicked

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("ship_clicked")
