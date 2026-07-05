class_name sb_ReorderList
extends HBoxContainer

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
			if get_local_mouse_position().x < child.position.x + child.size.x/2:
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
	return data is sb_DragTarget
