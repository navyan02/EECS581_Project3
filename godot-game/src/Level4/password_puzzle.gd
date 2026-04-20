extends Node2D

@export var password : String = "earthalienhome"
var lockedInLetters : String = "_".repeat(password.length())
var index : int = 0
var guess : String = ""
var success : bool = false

@onready var audioStreamPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D
var wrongSound = preload("res://assets/soundEffects/wrong.mp3")
var correctSound = preload("res://assets/soundEffects/zing.mp3")
var stopInput = false

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
	if (stopInput):
		return
		
	print(button_name, " was pressed")
	guess += button_name
	
	print(guess)
	
#	Append a green letter is that is the correct letter for that index in the password. 
#	Otherwise append a white letter.
	if (password[index] == button_name):
		appendLetter(button_name, true)
	else:
		appendLetter(button_name, false)
		
#	If the entire password has been filled in, check if it is correct. 
	if (index == password.length() - 1):
		if (guess == password):
			# right passcode
			audioStreamPlayer.stop()
			audioStreamPlayer.stream = correctSound
			audioStreamPlayer.play()
			get_tree().change_scene_to_file("res://src/Level4/level4Endscene.tscn")

		else:			
			# Wrong passcode
			audioStreamPlayer.stop()
			audioStreamPlayer.stream = wrongSound
			audioStreamPlayer.play()
			stopInput = true
			await get_tree().create_timer(1.5).timeout
			stopInput = false
			
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
