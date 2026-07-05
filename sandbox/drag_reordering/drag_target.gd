class_name sb_DragTarget
extends ColorRect

var is_dragging: bool = false

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			if get_viewport().gui_get_drag_data() == self:
				is_dragging = true
				modulate = Color.TRANSPARENT
		NOTIFICATION_DRAG_END:
			if is_dragging:
				visible = true
				modulate = Color.WHITE

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(self.duplicate())
	return self
