extends Control
class_name InventorySystem

signal item_picked_up(item: ItemData)
signal item_dropped(item: ItemData)

@export var slot_scene: PackedScene
@export var max_slots: int = 10
@export var slot_size: Vector2 = Vector2(64, 64)

var inventory: Array[ItemData] = []
var slots: Array[InventorySlot] = []
var dragging_item: ItemData = null
var dragging_slot: InventorySlot = null

#@onready var slots_container = $SlotsContainer
@onready var slots_container = $Panel/SlotsContainer 

func _ready():
	_create_slots()

func _create_slots():
	for i in max_slots:
		var slot = slot_scene.instantiate() as InventorySlot
		slot.slot_index = i
		slot.custom_minimum_size = slot_size
		slot.item_clicked.connect(_on_slot_clicked)
		slot.drag_started.connect(_on_drag_started)
		slots_container.add_child(slot)
		slots.append(slot)

func add_item(item: ItemData) -> bool:
	if inventory.size() >= max_slots:
		return false
	
	inventory.append(item)
	_update_slots()
	item_picked_up.emit(item)
	return true

func remove_item(item: ItemData) -> bool:
	var idx = inventory.find(item)
	if idx != -1:
		inventory.remove_at(idx)
		_update_slots()
		item_dropped.emit(item)
		return true
	return false

func _update_slots():
	for i in slots.size():
		if i < inventory.size():
			slots[i].set_item(inventory[i])
		else:
			slots[i].clear_item()

func _on_slot_clicked(slot: InventorySlot):
	if slot.item_data:
		print("Clicked item: ", slot.item_data.item_name)

func _on_drag_started(slot: InventorySlot):
	if slot.item_data:
		dragging_item = slot.item_data
		dragging_slot = slot
		slot.set_dragging(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			if dragging_item:
				_handle_drop()

func _handle_drop():
	if dragging_item:
		var mouse_pos = get_global_mouse_position()
		var dropped_on = _get_interactable_at_position(mouse_pos)
		
		if dropped_on and dropped_on.has_method("handle_item_drop"):
			dropped_on.handle_item_drop(dragging_item, self)
		#	Note that inventory_slot.gd handles returning the item to the inventory when dropped
		
		if dragging_slot:
			dragging_slot.set_dragging(false)
		
		dragging_item = null
		dragging_slot = null

func _get_interactable_at_position(pos: Vector2) -> Node:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collide_with_areas = true
	
	var results = space_state.intersect_point(query)
	for result in results:
		var collider = result.collider
		if collider.has_method("handle_item_drop"):
			return collider
	return null

func _is_over_inventory(pos: Vector2) -> bool:
	var rect = get_global_rect()
	return rect.has_point(pos)

func get_dragging_item() -> ItemData:
	return dragging_item
