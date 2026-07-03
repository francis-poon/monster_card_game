class_name InventoryCard
extends Control

signal card_pressed(card: InventoryCard)

@export var card_text: Label

var card_id: int:
	set(p_value):
		card_id = p_value
		var card_data: CardData = Globals.get_card(card_id)
		card_text.text = "{0}\n{1}".format([CardData.CardType.keys()[card_data.card_type], card_data.modifier])

func construct(p_card_id: int = 0) -> InventoryCard:
	card_id = p_card_id
	return self

func _on_button_pressed() -> void:
	card_pressed.emit(self)
