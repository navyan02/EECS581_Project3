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
			
			var row1 = $"Enter Password/Row1"
			var row2 = $"Enter Password/Row2"
			var row3 = $"Enter Password/Row3"
			for row in [row1, row2, row3]:
				for n in row.get_children():
					row.remove_child(n)
					n.queue_free()
	else:
		index += 1
			
func appendLetter(button_name, correct):
	# Subtract 65 because 'A' is 65
	var indexInAlphabet = button_name.to_upper().unicode_at(0) - 65
	var frameNumber = indexInAlphabet
#	Skip row 2 and go straight to row 3
	if indexInAlphabet >=9:
		frameNumber += 9
#	Skip row 4 and go straight to row 5
	if indexInAlphabet >= 18:
		frameNumber += 9
		
	var gridCont = null
	if (index < 5):
		gridCont = $"Enter Password/Row1"
	elif (index < 10):
		gridCont = $"Enter Password/Row2"
	else:
		gridCont = $"Enter Password/Row3"
			
	if (correct):
		var letter = $CorrectLetter.duplicate()
		letter.get_child(0).frame = frameNumber
		gridCont.add_child(letter)
	else:
		var letter = $IncorrectLetter.duplicate()
		letter.get_child(0).frame = frameNumber
		gridCont.add_child(letter)
