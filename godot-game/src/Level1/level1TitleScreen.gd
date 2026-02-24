extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("fade-in")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade-in":
		await get_tree().create_timer(3).timeout
		$AnimationPlayer.play("fade-out")
