class_name PlayableDeck

var deck_data: DeckData
var draw_pile: Array
var discard_pile: Array

func _init(p_deck_data: DeckData = DeckData.new()):
	deck_data = p_deck_data
	draw_pile = deck_data.cards.duplicate()
	discard_pile = []

func shuffle():
	draw_pile.append_array(discard_pile)
	discard_pile = []
	draw_pile.shuffle()


func can_draw() -> bool:
	return not draw_pile.is_empty() or not discard_pile.is_empty()

func draw() -> int:
	assert(deck_data.cards.size() > 0, "Deck is empty. Cannot draw.")
	assert(can_draw(), "All cards drawn.")
	
	if draw_pile.is_empty():
		shuffle()
	return draw_pile.pop_back()

func discard(card: int):
	discard_pile.push_back(card)
