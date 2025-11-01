# ============================================
# Shelf (where beakers come from)
# ============================================
extends Area2D
class_name Shelf

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		pass  # Shelf can be clicked but does nothing when empty

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	if dropped_item.item_id == "beakers":
		_show_dialog("I don't want to put them back. They may come in handy.")
		# Item stays in inventory (don't remove it)
	else:
		_show_dialog("That doesn't belong on the shelf.")

func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
