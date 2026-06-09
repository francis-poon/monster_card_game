class_name PlayField
extends Control

@export var card_target_location: Control

var field_card: DraggableCard

func can_play() -> bool:
	return field_card != null

func add_card(card: DraggableCard) -> bool:
	if field_card == null:
		field_card = card
		field_card.card_dropped.emit(field_card)
		field_card.card_dropped.connect(_on_card_dropped)
		add_child(field_card)
		if card_target_location != null:
			field_card.position = card_target_location.position
		return true
	return false

func clear():
	if field_card != null:
		field_card.card_dropped.disconnect(_on_card_dropped)
		remove_child(field_card)
		field_card.queue_free()
	field_card = null

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is DraggableCard and field_card == null

func _drop_data(at_position: Vector2, data: Variant) -> void:
	field_card = data as DraggableCard
	field_card.card_dropped.emit(field_card)
	field_card.card_dropped.connect(_on_card_dropped)
	add_child(field_card)
	if card_target_location != null:
			field_card.position = card_target_location.position

func _on_card_dropped(card: DraggableCard):
	field_card.card_dropped.disconnect(_on_card_dropped)
	field_card = null
	remove_child(card)
