class_name InventoryCard
extends Control

signal card_pressed(card: InventoryCard)

@export var value_label: Label

var card_value: int:
	set(p_value):
		card_value = p_value
		value_label.text = str(p_value)

func construct(p_card_value: int = -1) -> InventoryCard:
	card_value = p_card_value
	return self

func _on_button_pressed() -> void:
	card_pressed.emit(self)
