extends Area2D

var hand_cursor = preload("res://assets/ui/cursorActiveSmall.png")
@export var minDistToInteract : float
@export var userDialog : String
@export var player : CharacterBody2D
@export var addToInventory : bool
@export var hideAfterInteracting : bool

func _ready():
	pass
	
func _process(delta):
	pass

func change_cursor_hand():
	Input.set_custom_mouse_cursor(hand_cursor)
	
func change_cursor_back():
	Input.set_custom_mouse_cursor(null)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
#		Wait until player finishes walking to the object.
#		This isn't working well and needs to be refactored. Lots of clicks aren't handled because the user can't get close enough to the item. 
		
		if $".".position.distance_to(player.position) < minDistToInteract:
			print(userDialog)
			if addToInventory:
				print("You put it in your inventory")
			if hideAfterInteracting:
				$"..".hide()
			
