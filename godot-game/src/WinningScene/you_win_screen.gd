extends CanvasLayer

func _ready() -> void:
	playYouWinAnim()
	
func playYouWinAnim():
	var youWinAnim = $AnimationPlayer
	youWinAnim.play("Fade In")
	# The only way I could get the full opacity screen flash to stop was by waiting a short amount of time to make the scene visisble after starting the animation
	await get_tree().create_timer(0.1).timeout

	visible = true

	await youWinAnim.animation_finished
	youWinAnim.play("sparkles")
