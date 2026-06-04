class_name TestDraggable
extends ColorRect

signal card_dropped(card: TestDraggable)

func get_preview() -> Control:
	var preview_rect: ColorRect = ColorRect.new()
	preview_rect.custom_minimum_size = self.custom_minimum_size
	preview_rect.color = self.color
	return preview_rect

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
