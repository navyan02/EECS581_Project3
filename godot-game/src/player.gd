extends CharacterBody2D

var posToGoTo : Vector2

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		posToGoTo = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var vel = posToGoTo - self.global_position
	vel = vel.clamp(Vector2(-100, -100), Vector2(100, 100))
	velocity = vel
	move_and_slide()
	
