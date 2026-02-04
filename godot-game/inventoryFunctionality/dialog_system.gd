extends CanvasLayer
class_name DialogSystem

@export var typewriter_speed: float = 0.03  # seconds per character

@onready var dialog_panel = $Panel
@onready var dialog_label = $Panel/MarginContainer/Label
@onready var audioPlayer = $AudioStreamPlayer2D

var timer: Timer
var typing := false
var full_text := ""
var typing_index := 0
var current_duration := 0.0

# Signal emitted when dialog is finished (either naturally or clicked away)
signal dialog_finished

func _ready():
	add_to_group("dialog")
	
	# Create timer programmatically
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	# Initially hide the dialog.
	hide_dialog()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if dialog_panel.visible:
			_handle_dialog_click()
			if get_viewport():
				get_viewport().set_input_as_handled()

func _handle_dialog_click():
	if typing:
		# Stop typing and show full text immediately
		typing = false
		dialog_label.text = full_text
		typing_index = full_text.length()
		audioPlayer.stop()
		
		# Start the display timer now that text is complete
		timer.start(current_duration)
	else:
		# Text is already fully displayed, hide the dialog
		hide_dialog()

func show_message(text: String, duration: float = 3.0, playTypingSound: bool = true):
	# Stop any existing timer first to prevent premature hiding
	timer.stop()
	
	full_text = text
	current_duration = duration
	dialog_label.text = ""
	dialog_panel.visible = true
	
	typing = true
	typing_index = 0
	
	# Always stop the audio player attached to the dialog system before playing the next sound
	# Because if we don't stop it, the typewriting could overlap with audio lines potentially
	audioPlayer.stop()
	
	if playTypingSound:
		audioPlayer.play()
		
	_process_typewriter(duration)

func _process_typewriter(duration) -> void:
	if not typing:
		return
	
	if typing_index < full_text.length():
		dialog_label.text = full_text.substr(0, typing_index + 1)
		typing_index += 1
		
#		Fix bug that crashes the scene where the data tree is null
# 		This person had the same issue and solved it by checking the node was inside the tree before calling get_tree
#		https://www.reddit.com/r/godot/comments/18ttaau/i_keep_getting_an_error_that_data_tree_is_null/ 
		if not is_inside_tree():
			return

		await get_tree().create_timer(typewriter_speed).timeout
		_process_typewriter(duration)
	else:
		# Finished typing - start the display timer
		typing = false
		audioPlayer.stop()
		timer.start(duration)

func _on_timer_timeout():
	hide_dialog()
	
func hide_dialog():
	dialog_panel.visible = false
	timer.stop()
	typing = false
	dialog_finished.emit()
