extends Node2D

@export var password : String = "earthalienhome"
var lockedInLetters : String = "_".repeat(password.length())
var index : int = 0
var guess : String = ""
var success : bool = false

func _ready():
	for button in $"Translation Guide/Buttons".get_children():
		# Check if the child is actually a button to avoid errors
		print(button)
		if button is Button:
			# Connect the 'pressed' signal to a handler function
			button.pressed.connect(_on_button_pressed.bind(button.name))

# Handler function
func _on_button_pressed(button_name):
	if (success):
		return
		
	print(button_name, " was pressed")
	guess += button_name
	
	print(guess)
	
	if (password[index] == button_name):
		appendLetter(button_name, true)
	else:
		appendLetter(button_name, false)
		
	if (index == password.length() - 1):
		if (guess == password):
			print("Success")
		else:
			print("start over")
			index = 0
			guess = ""
			
			var fiveCol = $"Enter Password/RealLetters5Col"
			var fourCol = $"Enter Password/RealLetters4Col"
			for n in fiveCol.get_children():
				fiveCol.remove_child(n)
				n.queue_free()
			for n in fourCol.get_children():
				fourCol.remove_child(n)
				n.queue_free()
	else:
		index += 1
			
func appendLetter(button_name, correct):
	var letterToFrame = {'a': 1, 'b':2, 'c':3,}	
	var gridCont = null
	if (index < 10):
		gridCont = $"Enter Password/RealLetters5Col"
	else:
		gridCont = $"Enter Password/RealLetters4Col"
			
	if (correct):
		var letter = $CorrectLetter.duplicate()
		letter.get_child(0).frame = index
		gridCont.add_child(letter)
	else:
		var letter = $IncorrectLetter.duplicate()
		letter.get_child(0).frame = index
		gridCont.add_child(letter)
