class_name DeckEditor
extends Control

signal close
signal save(inventory: DeckData, untamed_cards:DeckData, deck: DeckData)

@export var inventory_display: DeckDisplay
@export var untamed_card_display: DeckDisplay
@export var deck_display: DeckDisplay
@export var save_button: Button
@export var deck_count_label: Label
@export var deck_cost_label: Label
@export var valid_deck_font_color: Color
@export var invalid_deck_font_color: Color


var deck: DeckData
var inventory: DeckData
var untamed_cards: DeckData
var deck_size: int
var deck_cost_capacity: int

func _ready():
	if not get_tree().root.get_child(1) == self or not Globals.developer_mode:
		return
	print("Deck Editor running in developer mode")
	untamed_cards = DeckData.new()
	inventory = DeckData.new([1, 2, 3, 4, 5, 6, 7])
	deck = DeckData.new([1, 1, 2, -1, -1])
	
	inventory_display.load_deck_data(inventory, {})
	untamed_card_display.load_deck_data(untamed_cards, {})
	deck_display.load_deck_data(deck, {})
	

func load_deck(p_inventory: DeckData, p_untamed_cards: DeckData, p_deck: DeckData,
	p_deck_size: int, p_deck_cost_capacity: int, p_card_cost_modifiers: Dictionary):
	inventory = p_inventory
	untamed_cards = p_untamed_cards
	deck = p_deck
	deck_size = p_deck_size
	deck_cost_capacity = p_deck_cost_capacity
	
	inventory_display.load_deck_data(p_inventory, p_card_cost_modifiers)
	untamed_card_display.load_deck_data(p_untamed_cards, p_card_cost_modifiers)
	deck_display.load_deck_data(p_deck, p_card_cost_modifiers)
	_update_save_button()
	_update_deck_info_labels()


func _is_deck_valid() -> bool:
	var is_valid: bool = deck_display.get_deck_count() == deck_size \
		and deck_display.get_deck_cost() <= deck_cost_capacity
	
	return is_valid

func _update_save_button():
	save_button.disabled = not _is_deck_valid()

func _update_deck_info_labels():
	var deck_count: int = deck_display.get_deck_count()
	var deck_cost: int = deck_display.get_deck_cost()
	
	deck_count_label.text = "Cards: {0}/{1}".format([deck_count, deck_size])
	deck_count_label.add_theme_color_override("font_color", valid_deck_font_color)
	if deck_count != deck_size:
		deck_count_label.add_theme_color_override("font_color", invalid_deck_font_color)
	
	deck_cost_label.text = "Capacity: {0}/{1}".format([deck_cost, deck_cost_capacity])
	deck_cost_label.add_theme_color_override("font_color", valid_deck_font_color)
	if deck_cost > deck_cost_capacity:
		deck_cost_label.add_theme_color_override("font_color", invalid_deck_font_color)

func _on_inventory_display_card_pressed(card: InventoryCard) -> void:
	inventory_display.remove_card(card)
	deck_display.add_card(card)
	_update_save_button()
	_update_deck_info_labels()

func _on_untamed_card_display_card_pressed(card: InventoryCard) -> void:
	untamed_card_display.remove_card(card)
	deck_display.add_card(card)
	_update_save_button()
	_update_deck_info_labels()

func _on_deck_display_card_pressed(card: InventoryCard) -> void:
	deck_display.remove_card(card)
	if card.card_id >= 0:
		inventory_display.add_card(card)
	else:
		untamed_card_display.add_card(card)
	_update_save_button()
	_update_deck_info_labels()


func _on_save_button_pressed() -> void:
	deck.cards = deck_display.get_deck_data().cards
	inventory.cards = inventory_display.get_deck_data().cards
	untamed_cards.cards = untamed_card_display.get_deck_data().cards
	save.emit(inventory, untamed_cards, deck)


func _on_close_button_pressed() -> void:
	close.emit()
