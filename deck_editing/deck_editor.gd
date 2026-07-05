class_name DeckEditor
extends Control

signal close
signal save(inventory: DeckData, deck: DeckData)

@export var inventory_display: DeckDisplay
@export var deck_display: DeckDisplay

var deck: DeckData
var inventory: DeckData

func _ready():
	if not get_tree().root.get_child(1) == self or not Globals.developer_mode:
		return
	print("Deck Editor running in developer mode")
	deck = ResourceLoader.load("res://resources/player_deck.tres")
	inventory = ResourceLoader.load("res://resources/inventory.tres")
	deck_display.load_deck_data(deck)
	inventory_display.load_deck_data(inventory)
	

func load_deck(p_inventory: DeckData, p_deck: DeckData):
	inventory = p_inventory
	deck = p_deck
	
	inventory_display.load_deck_data(p_inventory)
	deck_display.load_deck_data(p_deck)

func save_deck():
	# return inventory and deck data
	pass


func _on_inventory_display_card_pressed(card: InventoryCard) -> void:
	inventory_display.remove_card(card)
	deck_display.add_card(card)


func _on_deck_display_card_pressed(card: InventoryCard) -> void:
	deck_display.remove_card(card)
	inventory_display.add_card(card)


func _on_save_button_pressed() -> void:
	deck.cards = deck_display.get_deck_data().cards
	inventory.cards = inventory_display.get_deck_data().cards
	save.emit(inventory, deck)


func _on_close_button_pressed() -> void:
	close.emit()
