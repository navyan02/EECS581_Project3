# ============================================
# Beakers on Shelf
# ============================================
extends WorldItem
class_name Beakers

func _ready():
	super._ready()
	item_data.item_id = "beakers"
	item_data.item_name = "Beakers"
	item_data.pickup_dialog = "These are some interesting chemicals. Maybe they'll help me later."
