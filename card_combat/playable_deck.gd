class_name PlayableDeck

var deck_data: DeckData
var draw_pile: Array
var discard_pile: Array

func _init(p_deck_data: DeckData = DeckData.new()):
	deck_data = p_deck_data
	draw_pile = []
	discard_pile.resize(deck_data.cards.size())

func shuffle():
	draw_pile = deck_data.cards.duplicate()
	draw_pile.shuffle()

func draw() -> int:
	assert(deck_data.cards.size() > 0, "Deck is empty. Cannot draw.")
	
	if draw_pile.is_empty():
		shuffle()
	return draw_pile.pop_front()

func discard(card: int):
	discard_pile.push_back(card)
