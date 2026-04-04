extends CharacterBody2D

@export var speed = 650
@export var acceleration = 30  # How quickly you reach target speed
@export var friction = 0.3    # How much velocity is retained (1.0 = no friction, 0.0 = instant stop)
@export var stoppingDistance = 20

var posToGoTo : Vector2

var idleAnim
var moveLeftAnim
var moveRightAnim

func _ready() -> void:
	idleAnim = "alien_idle"
	moveLeftAnim = "alien_walk_left"
	moveRightAnim = "alien_walk_right"
		
#	The position to go to should initially be wherever the alien is standing.
	posToGoTo = global_position
	
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
	print(target_pos)
	posToGoTo = target_pos
	
func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
