extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	Since the animation player is in the levelTitleScreen scene, we have to use code to connect the animation finished signal to our own custom signal. 
	$LevelTitleScreen/AnimationPlayer.animation_finished.connect(_on_LevelTitleScreen_anim_finished)

func _on_LevelTitleScreen_anim_finished(anim_name: StringName) -> void:
	if anim_name == "fade-out":
		$LevelTitleScreen.visible = false
