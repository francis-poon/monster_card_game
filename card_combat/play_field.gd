class_name PlayField
extends Control

signal play_card(card: CardData)

@export var card_target_location: Control

func add_card(card: DraggableCard):
	card.card_dropped.emit(card)
	add_child(card)
	if card_target_location != null:
		card.position = card_target_location.position
	card.disable_drag()
	play_card.emit(card.card_data)
	var tween = get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(1.2, 1.2), 1.0)
	tween.parallel().tween_property(card, "modulate", Color.TRANSPARENT, 1.0)
	tween.tween_callback(remove_child.bind(card))
	tween.tween_callback(card.queue_free)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is DraggableCard

func _drop_data(at_position: Vector2, data: Variant) -> void:
	add_card(data)
