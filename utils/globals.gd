extends Node

var developer_mode: bool = true
var card_index: Dictionary = _init_card_index()


func get_save_dir_root() -> String:
	if developer_mode:
		return "res://saves/"
	else:
		return "user://saves/"

func _init_card_index() -> Dictionary:
	var index_data: DeckData = ResourceLoader.load("res://resources/card_index_data.tres")
	var p_card_index: Dictionary = {}
	for card in index_data.cards:
		card = card as CardData
		p_card_index[card.card_id] = card
	return p_card_index

func get_card(card_id: int) -> CardData:
	if card_id in card_index.keys():
		return card_index[card_id]
	return CardData.new()
