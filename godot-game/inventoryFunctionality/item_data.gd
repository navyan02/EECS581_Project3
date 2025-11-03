extends Resource
class_name ItemData

@export var item_id: String = ""
@export var item_name: String = ""
@export var icon: Texture2D
@export var pickup_dialog: String = ""

func _init(p_id: String = "", p_name: String = "", p_icon: Texture2D = null, p_dialog: String = ""):
	item_id = p_id
	item_name = p_name
	icon = p_icon
	pickup_dialog = p_dialog
