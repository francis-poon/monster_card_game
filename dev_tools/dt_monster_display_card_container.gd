class_name DTMonsterDisplayCardContainer
extends VBoxContainer

var dropping: bool
var drag_data: Variant
var drag_data_start_idx: int

func _ready():
	dropping = false
	drag_data = null
	drag_data_start_idx = 0

func _process(delta: float) -> void:
	if dropping:
		# check local mouse position against children position and move drag
		# data to new idx if it passes another child
		var idx: int = 0
		for child in get_children():
			if child == drag_data:
				continue
			if get_local_mouse_position().y < child.position.y + child.size.y/2:
				break
			idx += 1
		if idx != drag_data_start_idx:
			move_child(drag_data, idx)
			drag_data_start_idx = idx

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			drag_data = get_viewport().gui_get_drag_data()
			drag_data_start_idx = drag_data.get_index()
			dropping = _can_drop_data(Vector2.ZERO, drag_data)
		NOTIFICATION_DRAG_END:
			dropping = false

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is DTIndexMonsterDisplay and data.get_parent() and data.get_parent() == self

func get_monster_list() -> Array:
	var monster_list: Array = []
	for child in get_children():
		if child is not DTIndexMonsterDisplay:
			continue
		child = child as DTIndexMonsterDisplay
		monster_list.append(child.tamed_monster_data.uid)
	return monster_list
