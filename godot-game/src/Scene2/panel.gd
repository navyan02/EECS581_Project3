extends Panel

#@export var dialogue_line: String = ""
@export var chars_per_second: float = 30.0
@export var auto_hide_after: float = -1.0  # -1 = don't hide

@onready var label: Label = $Label

var _full_text := ""
var _index := 0

func _ready() -> void:
	visible = true
	modulate.a = 1.0
	label.visible = true

	# Make sure label can wrap if needed
	label.autowrap_mode = TextServer.AUTOWRAP_WORD

	#start(dialogue_line)

func start(text: String) -> void:
	_full_text = text
	_index = 0
	label.text = ""
	_type_next_char()

func _type_next_char() -> void:
	if _index >= _full_text.length():
		if auto_hide_after >= 0.0:
			await get_tree().create_timer(auto_hide_after).timeout
			visible = false
		return

	label.text += _full_text[_index]
	_index += 1

	var delay: float = 1.0 / chars_per_second
	await get_tree().create_timer(delay).timeout
	_type_next_char()
