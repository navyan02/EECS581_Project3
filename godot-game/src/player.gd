extends CharacterBody2D

var posToGoTo : Vector2
var speed = 300
var controlMode = "mouse"
# In the future, implement controlMode = "keyboard" for wasd controls.
	
# Get input
# I used _unhandled_input() instead of just _input() so that the inventory has a chance to handle inventory clicks
# This way, only clicks outside of the UI will trigger movement!
func _unhandled_input(event: InputEvent) -> void:
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
