extends Area2D

func handle_item_drop(dropped_item: ItemData, inventory: InventorySystem):
	if dropped_item.item_id == "translatorTable":
		_show_dialog("I've got my translator tablet!")
		# Item stays in inventory (don't remove it)
	else:
		_show_dialog("I don't think this will help me get my team out of alien jail")


func _show_dialog(text: String):
	var dialog = get_tree().get_first_node_in_group("dialog")
	if dialog and dialog.has_method("show_message"):
		dialog.show_message(text)
	else:
		print("Dialog: ", text)
