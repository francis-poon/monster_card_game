class_name CardHand
extends Control

@export var card_container: HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in card_container.get_children():
		if child is DraggableCard:
			child.card_dropped.connect(_on_card_dropped)

func add_card(card: DraggableCard):
	card.card_dropped.connect(_on_card_dropped)
	card_container.add_child(card)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if data is DraggableCard:
		return true
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	var card: DraggableCard = data as DraggableCard
	card.card_dropped.emit(card)
	card.card_dropped.connect(_on_card_dropped)
	card_container.add_child(card)

func _on_card_dropped(card: DraggableCard):
	card.card_dropped.disconnect(_on_card_dropped)
	card_container.remove_child(card)
