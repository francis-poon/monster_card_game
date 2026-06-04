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

func play_random_card() -> DraggableCard:
	var rand_child_idx: int = randi_range(0, card_container.get_child_count() - 1)
	var rand_card: DraggableCard = card_container.get_children()[rand_child_idx]
	
	rand_card.card_dropped.disconnect(_on_card_dropped)
	card_container.remove_child(rand_card)
	
	return rand_card

func clear():
	for child in card_container.get_children():
		if child is DraggableCard:
			child.card_dropped.disconnect(_on_card_dropped)
			card_container.remove_child(child)
		child.queue_free()

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
