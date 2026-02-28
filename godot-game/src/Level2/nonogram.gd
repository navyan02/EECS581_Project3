extends Node2D

# Enums for cell states
enum CellState {
	BLANK,
	X,
	FILLED
}

# Current tool selected by the player
var current_tool: CellState = CellState.FILLED

# Grid size
const GRID_SIZE = 5

# Store the state of each cell
var grid_state: Array = []
var still_playing = true

# References to UI elements (assign these in the editor)
@export var blank_button: TextureButton
@export var x_button: TextureButton
@export var fill_button: TextureButton
@export var zoomedAccessButtons: AnimatedSprite2D
@export var accessGrantedMessage: Node2D

# Grid sprite reference (assign in the editor)
@export var grid_sprite: Sprite2D

# Calculated grid cell size and offset
var cell_size: Vector2
var grid_offset: Vector2

# Border ratio - what fraction of the grid width/height is border space
# For a 5x5 grid with equal borders, there are 6 border sections (top, bottom, and 4 between cells)
# and 5 cell sections. Adjust this value to match your grid artwork's border size.
@export var border_ratio: float = 0.1  # 10% of grid is borders by default

# Sprite references for cell states (assign your artwork in the editor)
@export var blank_texture: Texture2D
@export var x_texture: Texture2D
@export var fill_texture: Texture2D

# Array to store sprite nodes for each cell
var cell_sprites: Array = []

signal nonogram_solved()

func _ready():
	zoomedAccessButtons.play("Access Denied")
	# Calculate grid dimensions based on the grid sprite
	calculate_grid_dimensions()
	
	# Initialize the grid state
	for i in range(GRID_SIZE):
		grid_state.append([])
		for j in range(GRID_SIZE):
			grid_state[i].append(CellState.BLANK)
	
	# Create sprite nodes for each cell
	create_grid_sprites()
	
#	To give the player a hint as to how the puzzle works, lets partially solve the puzzle at the beginning
	fill_cell(2, 0, CellState.FILLED)
	fill_cell(2, 1, CellState.FILLED)
	fill_cell(2, 2, CellState.X)
	fill_cell(2, 3, CellState.FILLED)
	fill_cell(2, 4, CellState.FILLED)
	
	# Connect button signals
	if blank_button:
		blank_button.pressed.connect(_on_blank_button_pressed)
	if x_button:
		x_button.pressed.connect(_on_x_button_pressed)
	if fill_button:
		fill_button.pressed.connect(_on_fill_button_pressed)
	
	# Highlight the initial tool
	update_tool_buttons()

func calculate_grid_dimensions():
	"""Calculate cell size and grid offset based on the grid sprite"""
	if not grid_sprite or not grid_sprite.texture:
		push_error("Grid sprite or texture not assigned!")
		return
	
	# Get the actual size of the grid sprite (considering scale)
	var texture_size = grid_sprite.texture.get_size()
	var grid_size = texture_size * grid_sprite.scale
	
	# Get the top-left corner of the grid sprite
	# Sprites are centered by default, so we need to calculate the offset
	var grid_top_left = grid_sprite.global_position - (grid_size / 2.0)
	
	# Calculate the size of borders and cells
	# Total grid = borders + cells
	# For a 5x5 grid: 6 borders (top + 4 internal + bottom) and 5 cells
	var total_border_space = grid_size * border_ratio
	var total_cell_space = grid_size * (1.0 - border_ratio)
	
	# Individual border and cell sizes
	var border_size = total_border_space / 6.0  # 6 border sections
	var individual_cell_size = total_cell_space / 5.0  # 5 cells
	
	# Set the calculated values
	cell_size = individual_cell_size
	grid_offset = grid_top_left + border_size  # Start after the first border
	#
	#print("Grid calculations:")
	#print("  Grid size: ", grid_size)
	#print("  Grid top-left: ", grid_top_left)
	#print("  Cell size: ", cell_size)
	#print("  Border size: ", border_size)
	#print("  Grid offset: ", grid_offset)

func create_grid_sprites():
	"""Create sprite nodes for each grid cell"""
	for row in range(GRID_SIZE):
		cell_sprites.append([])
		for col in range(GRID_SIZE):
			var sprite = Sprite2D.new()
			sprite.texture = blank_texture
			
			# Calculate sprite scale to fit the cell
			if blank_texture:
				var texture_size = blank_texture.get_size()
				var scale_factor = cell_size / texture_size
				sprite.scale = scale_factor
			
			# Position includes the spacing for borders between cells
			var border_spacing = (cell_size * border_ratio / (1.0 - border_ratio))
			var pos_x = col * (cell_size.x + border_spacing.x)
			var pos_y = row * (cell_size.y + border_spacing.y)
			
			# Center the sprite within the cell (sprites are centered by default at their position)
			sprite.position = grid_offset + Vector2(pos_x, pos_y) + (cell_size / 2.0)
			add_child(sprite)
			cell_sprites[row].append(sprite)

func _input(event):
	if not visible:
		return
	if not still_playing:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var cell = get_cell_from_position(mouse_pos)
		
		if cell != null and cell.x >= 0:
			fill_cell(cell.x, cell.y, current_tool)
			if (check_solution(rocket_solution)):
#				Prevent the player from continuing to play
				still_playing = false
				$"../Sound Effects/PuzzleComplete".play()
				nonogram_solved.emit()
				
#				Wait a moment for the player to see their finished nonogram
				await get_tree().create_timer(0.25).timeout
				
#				Start the access granted animation
				zoomedAccessButtons.play("Access Granted")
				accessGrantedMessage.visible = true
#				Wait a couple more seconds before showing the rocket ship animation
				await get_tree().create_timer(2).timeout
				accessGrantedMessage.get_node("AnimationPlayer").play("fly to top")
				await accessGrantedMessage.get_node("AnimationPlayer").animation_finished
				
#				Now we can hide the nonogram puzzle and go back to the space ship door
				await get_tree().create_timer(1).timeout
				visible = false
				
				
func get_cell_from_position(pos: Vector2) -> Vector2i:
	"""Convert mouse position to grid coordinates"""
	var relative_pos = pos - grid_offset
	
	# Calculate border spacing
	var border_spacing = (cell_size * border_ratio / (1.0 - border_ratio))
	var cell_with_border = cell_size + border_spacing
	
	# Check if click is within grid bounds
	if relative_pos.x < 0 or relative_pos.y < 0:
		return Vector2i(-1, -1)
	if relative_pos.x >= GRID_SIZE * cell_with_border.x or relative_pos.y >= GRID_SIZE * cell_with_border.y:
		return Vector2i(-1, -1)
	
	var col = int(relative_pos.x / cell_with_border.x)
	var row = int(relative_pos.y / cell_with_border.y)
	
	return Vector2i(col, row)

func fill_cell(col: int, row: int, state: CellState):
	"""Fill a cell with the selected tool"""
	grid_state[row][col] = state
	update_cell_sprite(col, row)
	$"../Sound Effects/Click".play()
#	Stop the click from being used by other nodes
	get_viewport().set_input_as_handled()

func update_cell_sprite(col: int, row: int):
	"""Update the visual representation of a cell"""
	var sprite = cell_sprites[row][col]
	var state = grid_state[row][col]
	
	match state:
		CellState.BLANK:
			sprite.texture = blank_texture
		CellState.X:
			sprite.texture = x_texture
		CellState.FILLED:
			sprite.texture = fill_texture
	
	# Update scale when texture changes
	if sprite.texture:
		var texture_size = sprite.texture.get_size()
		var scale_factor = cell_size / texture_size
		sprite.scale = scale_factor

# Button callbacks
func _on_blank_button_pressed():
	current_tool = CellState.BLANK
	update_tool_buttons()

func _on_x_button_pressed():
	current_tool = CellState.X
	update_tool_buttons()

func _on_fill_button_pressed():
	current_tool = CellState.FILLED
	update_tool_buttons()

func update_tool_buttons():
	"""Visual feedback for selected tool (optional - customize as needed)"""
	if blank_button:
		blank_button.modulate = Color.WHITE if current_tool != CellState.BLANK else Color.YELLOW
	if x_button:
		x_button.modulate = Color.WHITE if current_tool != CellState.X else Color.YELLOW
	if fill_button:
		fill_button.modulate = Color.WHITE if current_tool != CellState.FILLED else Color.YELLOW

# |  .  |
# | ... |
# | . . |
# |.....|
# |. . .|
var rocket_solution = [
	[CellState.BLANK, CellState.BLANK, CellState.FILLED, CellState.BLANK, CellState.BLANK],
	[CellState.BLANK, CellState.FILLED, CellState.FILLED, CellState.FILLED, CellState.BLANK],
	[CellState.BLANK, CellState.FILLED, CellState.BLANK, CellState.FILLED, CellState.BLANK],
	[CellState.FILLED, CellState.FILLED, CellState.FILLED, CellState.FILLED, CellState.FILLED],
	[CellState.FILLED, CellState.BLANK, CellState.FILLED, CellState.BLANK, CellState.FILLED]
]
# Utility function to check solution (you'll need to define your puzzle)
func check_solution(solution: Array) -> bool:
	"""Compare current grid state with the solution"""
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
#			If the player filled a cell that should have been blank 
			if grid_state[row][col] == CellState.FILLED and solution[row][col] != CellState.FILLED:
				return false
#			If the player didn't fill a cell that should have been filled
			if solution[row][col] == CellState.FILLED and grid_state[row][col] != CellState.FILLED:
				return false
	return true

# Optional: Clear the grid
func clear_grid():
	for row in range(GRID_SIZE):
		for col in range(GRID_SIZE):
			fill_cell(col, row, CellState.BLANK)
