extends CharacterBody2D
class_name Alien

enum { IDLE, WANDER }

var state = IDLE
const TOLERANCE = 3.0
const SPEED = 50.0
const STEP_SIZE = 100.0
const STUCK_TIME_LIMIT = 1.0     # Seconds before deciding we're stuck
const STUCK_DIST_THRESHOLD = 25.0 # Minimum pixels we expect to travel

@onready var target_position = global_position
@onready var ray = RayCast2D.new()

var stuck_timer = 0.0
var stuck_check_origin = Vector2.ZERO  # Position when we last reset the timer

func _ready():
	add_child(ray)
	ray.enabled = true
	ray.collision_mask = 1

func get_open_directions() -> Array:
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	var open = []
	for dir in directions:
		ray.target_position = dir * STEP_SIZE
		ray.force_raycast_update()
		if not ray.is_colliding():
			open.append(dir)
	return open

func update_target_position():
	var open_dirs = get_open_directions()
	if open_dirs.is_empty():
		state = IDLE
		return
	var chosen = open_dirs[randi() % open_dirs.size()]
	target_position = global_position + chosen * STEP_SIZE
	# Reset stuck tracking whenever a new target is chosen
	stuck_timer = 0.0
	stuck_check_origin = global_position

func is_at_target_position():
	return (target_position - global_position).length() < TOLERANCE

func is_stuck(delta) -> bool:
	stuck_timer += delta
	if stuck_timer >= STUCK_TIME_LIMIT:
		var dist_traveled = (global_position - stuck_check_origin).length()
		if dist_traveled < STUCK_DIST_THRESHOLD:
			return true
		# Made progress — reset the window
		stuck_timer = 0.0
		stuck_check_origin = global_position
	return false

func _physics_process(delta):
	match state:
		IDLE:
			state = WANDER
#			I got rid of the idle waiting because it makes it feel choppy
			#await get_tree().create_timer(randf_range(0.5, 2.0)).timeout
			update_target_position()

		WANDER:
			if is_stuck(delta):
				update_target_position()
				return
			velocity = global_position.direction_to(target_position) * SPEED
			move_and_slide()
			if is_at_target_position():
				global_position = target_position
				state = IDLE
