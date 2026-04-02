extends CharacterBody2D

@export var speed = 550
@export var acceleration = 30  # How quickly you reach target speed
@export var friction = 0.3    # How much velocity is retained (1.0 = no friction, 0.0 = instant stop)
@export var stoppingDistance = 20

signal caughtByAlien

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
	
#	spawn all the raycasts
	generate_raycasts()
	
# Get input
# I used _unhandled_input() instead of just _input() so that the inventory has a chance to handle inventory clicks
# This way, only clicks outside of the UI will trigger movement!
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") && controlMode == "mouse":
		posToGoTo = get_global_mouse_position()

func _physics_process(delta: float) -> void:
	#var direction = global_position.direction_to(posToGoTo)
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	#var target_velocity = direction * speed
	velocity = direction * speed
	move_and_slide()
	
	#if global_position.distance_to(posToGoTo) > stoppingDistance:
		## Gradual acceleration toward target velocity
		#velocity = velocity.lerp(target_velocity, acceleration * delta)
		#move_and_slide()
		#
		## Animation logic
		##if abs(velocity.x) < 50 and abs(velocity.y) < 50:
			##$AnimationPlayer.play(idleAnim)
		##else:
			##if direction.x > 0.00:
				##$AnimationPlayer.play(moveRightAnim)
			##elif direction.x <= 0.00:
				##$AnimationPlayer.play(moveLeftAnim)
	#else:
		## Apply friction when near target
		#velocity *= friction
		#if velocity.length() > 1:
			#move_and_slide()
		##$AnimationPlayer.play(idleAnim)
		
	for ray in $Rays.get_children():
		if ray.is_colliding() and ray.get_collider() is Alien:
				caughtByAlien.emit()
				print("In range. You died")


var angle_cone_of_vision := deg_to_rad(360)
var max_view_distance := 25.0
var angle_between_rays := deg_to_rad(10)

func generate_raycasts() -> void:
	var ray_count := angle_cone_of_vision / angle_between_rays
	for index in ray_count:
		var ray := RayCast2D.new()
		var angle = angle_between_rays * (index - ray_count / 2.0)
		ray.target_position = Vector2.UP.rotated(angle) * max_view_distance
		$Rays.add_child(ray)
		ray.enabled = true

signal mazeWon

func _on_finish_line_area_entered(area: Area2D) -> void:
#	Make sure the area that entered the finish line was the player not an alien.
	if (area == $Area2D):
		print("You win")
		mazeWon.emit()
