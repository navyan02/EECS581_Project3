extends AnimationPlayer

@onready var anim = $AnimationPlayer
@onready var camera = $CutsceneCamera
@onready var message_label = $CanvasLayer/MessageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MusicPlayer.stop()
	play("endscene")
	await animation_finished
	MusicPlayer.play()
	#get_tree().change_scene_to_file("res://src/Office.tscn")

func show_message(text: String):
	message_label.text = text
	message_label.visible = true

func hide_message() -> void:
	message_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
