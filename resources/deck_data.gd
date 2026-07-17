class_name DeckData
extends Resource

@export var cards: Array

func _init(p_cards: Array = []):
	cards = p_cards

func to_untamed_deck() -> DeckData:
	var untamed_cards: Array = cards.duplicate()
	for i in range(untamed_cards.size()):
		untamed_cards[i] = abs(untamed_cards[i]) * -1
	return DeckData.new(untamed_cards)
