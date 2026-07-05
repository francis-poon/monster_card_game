class_name PlayField
extends Control

signal play_card(card: CardData)

@export var card_target_location: Control

func add_card(card: DraggableCard):
	card.card_dropped.emit(card)
	
	if card_target_location:
		card_target_location.add_child(card)
		card.set_anchors_and_offsets_preset(PRESET_CENTER)
	else:
		add_child(card)
		card.set_anchors_and_offsets_preset(PRESET_CENTER)
	card.disable_drag()
	play_card.emit(card.card_data)
	var tween = get_tree().create_tween()
	tween.tween_property(card, "scale", Vector2(1.2, 1.2), 1.0)
	tween.parallel().tween_property(card, "modulate", Color.TRANSPARENT, 1.0)
	if card_target_location:
		tween.tween_callback(card_target_location.remove_child.bind(card))
	else:
		tween.tween_callback(remove_child.bind(card))
	tween.tween_callback(card.queue_free)

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is DraggableCard

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	add_card(data)
