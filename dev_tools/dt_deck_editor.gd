class_name DTDeckEditor
extends Control

signal close
signal save(deck: DeckData)

@export var card_index_display: DeckDisplay
@export var deck_display: DeckDisplay
@export var save_button: Button
@export var card_count_label: Label
@export var capacity_count_label: Label
@export var invalid_deck_font_color: Color
@export var valid_deck_font_color: Color

var deck: DeckData
var card_index: DeckData
var deck_size: int
var deck_cost_capacity: int

	

func load_deck(p_card_index: DeckData, p_deck: DeckData,
	p_deck_size: int, p_deck_cost_capacity: int, p_card_cost_modifiers: Dictionary):
	card_index = p_card_index
	deck = p_deck
	deck_size = p_deck_size
	deck_cost_capacity = p_deck_cost_capacity
	
	card_index_display.load_deck_data(p_card_index, p_card_cost_modifiers)
	deck_display.load_deck_data(p_deck, p_card_cost_modifiers)
	_update_card_info_labels()


func _is_deck_valid() -> bool:
	var is_valid: bool = deck_display.get_deck_count() == deck_size \
		and deck_display.get_deck_cost() <= deck_cost_capacity
	
	return is_valid

func _update_save_button():
	save_button.disabled = not _is_deck_valid()

func _update_card_info_labels():
	var deck_count: int = deck_display.get_deck_count()
	var deck_cost: int = deck_display.get_deck_cost()
	
	card_count_label.text = "Cards: {0}/{1}".format([deck_count, deck_size])
	card_count_label.add_theme_color_override("font_color", valid_deck_font_color)
	if deck_count != deck_size:
		card_count_label.add_theme_color_override("font_color", invalid_deck_font_color)
	
	capacity_count_label.text = "Capacity: {0}/{1}".format([deck_cost, deck_cost_capacity])
	capacity_count_label.add_theme_color_override("font_color", valid_deck_font_color)
	if deck_cost > deck_cost_capacity:
		capacity_count_label.add_theme_color_override("font_color", invalid_deck_font_color)

func _on_deck_display_card_pressed(card: InventoryCard) -> void:
	deck_display.remove_card(card)
	card.queue_free()
	_update_card_info_labels()


func _on_save_button_pressed() -> void:
	deck.cards = deck_display.get_deck_data().cards
	save.emit(deck)


func _on_close_button_pressed() -> void:
	close.emit()


func _on_card_index_display_card_pressed(card: InventoryCard) -> void:
	deck_display.add_card(card.duplicate())
	_update_card_info_labels()
