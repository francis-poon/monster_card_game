class_name PlayField
extends Control

var field_card: DraggableCard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data is DraggableCard and field_card == null

func _drop_data(at_position: Vector2, data: Variant) -> void:
	field_card = data as DraggableCard
	field_card.card_dropped.emit(field_card)
	field_card.card_dropped.connect(_on_card_dropped)
	add_child(field_card)

func _on_card_dropped(card: DraggableCard):
	field_card.card_dropped.disconnect(_on_card_dropped)
	field_card = null
	remove_child(card)
