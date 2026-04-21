extends CharacterBody2D

@export var speed = 650
@export var acceleration = 30  # How quickly you reach target speed
@export var friction = 0.3    # How much velocity is retained (1.0 = no friction, 0.0 = instant stop)
@export var stoppingDistance = 20

enum costumes {
	REGULAR,
	ASTRONAUT
}

@export var costume : costumes = costumes.REGULAR

var posToGoTo : Vector2
var controlMode = "mouse"
# In the future, implement controlMode = "keyboard" for wasd controls.
	

var idleAnim
var moveLeftAnim
var moveRightAnim

func _ready() -> void:
	if costume == costumes.ASTRONAUT:
		idleAnim = "astronaut_idle"
		moveLeftAnim = "astronaut_fly_left"
		moveRightAnim = "astronaut_fly_right"
	else:
		idleAnim = "player_idle"
		moveLeftAnim = "player_walk_left"
		moveRightAnim = "player_walk_right"
		
#	The position to go to should initially be wherever the player is standing.
	posToGoTo = global_position
	
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
			$AnimationPlayer.play(idleAnim)
		else:
			if direction.x > 0.00:
				$AnimationPlayer.play(moveRightAnim)
			elif direction.x <= 0.00:
				$AnimationPlayer.play(moveLeftAnim)
	else:
		# Apply friction when near target
		velocity *= friction
		if velocity.length() > 1:
			move_and_slide()
		$AnimationPlayer.play(idleAnim)
		
func move_to_spot(target_pos: Vector2):
	posToGoTo = target_pos
	
func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
