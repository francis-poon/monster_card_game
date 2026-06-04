class_name DraggableCard
extends Control

signal card_dropped(card: DraggableCard)

@export var face: TextureRect
@export var value_label: Label

var card_value: int:
	set(value):
		card_value = value
		value_label.text = str(value)

func _ready() -> void:
	card_value = randi_range(1, 10)

func get_preview() -> Control:
	var preview_card: Control = Control.new()
	preview_card.custom_minimum_size = self.size
	preview_card.add_child(face.duplicate())
	preview_card.add_child(value_label.duplicate())
	return preview_card

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(get_preview())
	return self
