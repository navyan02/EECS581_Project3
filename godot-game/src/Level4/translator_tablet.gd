# ============================================
# Key item
# ============================================
extends WorldItem
class_name TranslatorTablet

#@export var audioPlayer : AudioStreamPlayer2D

func _ready():
	super._ready()
	item_data.item_id = "translatorTablet"
	item_data.item_name = "Translator Tablet"
	item_data.pickup_dialog = "I can translate Alienese with this!"


#func _on_large_book_shelf_puzzle_solved() -> void:
	#print("Key saw the puzzle was solved")
	#visible = true
	#if audioPlayer:
		#audioPlayer.play()
