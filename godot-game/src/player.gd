extends CharacterBody2D

var posToGoTo : Vector2
var speed = 300
var controlMode = "mouse"
# In the future, implement controlMode = "keyboard" for wasd controls.
	
# Get input
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && controlMode == "mouse":
		posToGoTo = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	velocity = position.direction_to(posToGoTo) * speed
	
	if position.distance_to(posToGoTo) > 5:
		move_and_slide()
		#print(velocity)
		if abs(velocity[0]) < 1 and abs(velocity[1]) < 1:
			#print("Not Moving")
			$AnimationPlayer.play("player_idle")
		else:
			if position.direction_to(posToGoTo)[0] > 0.00:
				#print("right")
				$AnimationPlayer.play("player_walk_right")
			elif position.direction_to(posToGoTo)[0] <= 0.00:
				#print("left")
				$AnimationPlayer.play("player_walk_left")
	else: 
		#print("Not moving")
		$AnimationPlayer.play("player_idle")
