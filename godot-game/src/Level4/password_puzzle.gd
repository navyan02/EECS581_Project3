extends Node2D

@export var password : String = "earthalienhome"
var lockedInLetters : String = "_".repeat(password.length())
var index : int = 0
var guess : String = ""

func _ready():
	for button in $"Translation Guide/Buttons".get_children():
		# Check if the child is actually a button to avoid errors
		print(button)
		if button is Button:
			# Connect the 'pressed' signal to a handler function
			button.pressed.connect(_on_button_pressed.bind(button.name))

# Handler function
func _on_button_pressed(button_name):
	print(button_name, " was pressed")
	guess += button_name
	print(guess)
	
	if (password[index] == button_name):
		print("Correct letter to index")
	
	if (index == password.length() - 1):
		print("start over")
		index = 0
		guess = ""
	else:
		index += 1
			
