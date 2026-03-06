extends Node2D

func _on_intern_head_caught_by_alien() -> void:
	$"You Died".visible = true
	
	if get_tree():
		await get_tree().create_timer(3.0).timeout

		get_tree().call_deferred("reload_current_scene")
