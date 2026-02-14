extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.color.a = 0.0 # Replace with function body.
