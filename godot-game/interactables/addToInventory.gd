extends Area2D

var currentInteractions := []
var canInteract := true

func _on_input_event(area: Area2D, event: InputEvent) -> void:
	if event.is_action("left_click"):
		print("Left clicked")
		await area.interact.call()
	
