extends CharacterBody2D

@export var speed = 650
@export var acceleration = 30  # How quickly you reach target speed
@export var friction = 0.3    # How much velocity is retained (1.0 = no friction, 0.0 = instant stop)
@export var stoppingDistance = 20

var posToGoTo : Vector2
var controlMode = "mouse"
# In the future, implement controlMode = "keyboard" for wasd controls.
	
# Get input
# I used _unhandled_input() instead of just _input() so that the inventory has a chance to handle inventory clicks
# This way, only clicks outside of the UI will trigger movement!
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && controlMode == "mouse":
		posToGoTo = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(posToGoTo)
	var target_velocity = direction * speed
	
	if global_position.distance_to(posToGoTo) > stoppingDistance:
		# Gradual acceleration toward target velocity
		velocity = velocity.lerp(target_velocity, acceleration * delta)
		move_and_slide()
		
		# Animation logic
		if abs(velocity.x) < 50 and abs(velocity.y) < 50:
			$AnimationPlayer.play("player_idle")
		else:
			if direction.x > 0.00:
				$AnimationPlayer.play("player_walk_right")
			elif direction.x <= 0.00:
				$AnimationPlayer.play("player_walk_left")
	else:
		# Apply friction when near target
		velocity *= friction
		if velocity.length() > 1:
			move_and_slide()
		$AnimationPlayer.play("player_idle")
