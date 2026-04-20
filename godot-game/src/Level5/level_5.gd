extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("cellDoorsOpen")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("leaveTheCells")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("dialog")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("alienWalksIn")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _show_dialog(text: String, howLong: float):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text, howLong)
	else:
		print("Dialog: ", text)
