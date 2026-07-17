class_name DeckDisplay
extends Control

signal card_pressed(card: InventoryCard)

@export var card_grid: GridContainer
@export var card_scene: PackedScene

# TODO: Marked for deletion. Was used for testing before deck save data was made
func generate_random_deck(card_count: int):
	for c in range(card_count):
		var card: InventoryCard = card_scene.instantiate().construct(randi_range(0,4))
		
		card.custom_minimum_size = Vector2(0, 200)
		card_grid.add_child(card)
		card.card_pressed.connect(_on_card_pressed)

func add_card(card: InventoryCard):
	card.card_pressed.connect(_on_card_pressed)
	card_grid.add_child(card)

func remove_card(card: InventoryCard):
	card.card_pressed.disconnect(_on_card_pressed)
	card_grid.remove_child(card)

func clear_cards():
	for child in card_grid.get_children():
		remove_card(child)
		child.queue_free()

func load_deck_data(deck: DeckData, card_cost_modifiers: Dictionary):
	clear_cards()
	for card in deck.cards:
		var cost_modifier: int = 0 if not card in card_cost_modifiers else card_cost_modifiers[card]
		var new_card: InventoryCard = card_scene.instantiate().construct(card, cost_modifier)
		new_card.custom_minimum_size = Vector2(0, 136)
		add_card(new_card)

func get_deck_data() -> DeckData:
	var deck_data: DeckData = DeckData.new()
	for child in card_grid.get_children():
		if child is InventoryCard:
			deck_data.cards.append(child.card_id)
	return deck_data

func get_deck_count() -> int:
	return card_grid.get_child_count()

func get_deck_cost() -> int:
	var total_cost: int = 0
	
	for child in card_grid.get_children():
		child = child as InventoryCard
		total_cost += (Globals.get_card(child.card_id).cost + child.cost_modifier)
	return total_cost

func _on_card_pressed(card: InventoryCard):
	card_pressed.emit(card)
