class_name DTCostModifierEditor
extends Control

signal close
signal save(cost_modifiers: Dictionary)

@export var card_index_display: DeckDisplay
@export var cost_modifier_display: DTCostModifierDisplay


func load_cost_modifiers(p_card_index: DeckData, p_card_cost_modifiers: Dictionary):
	card_index_display.load_deck_data(p_card_index, p_card_cost_modifiers)
	cost_modifier_display.load_cost_modifiers(p_card_cost_modifiers)


func _on_card_index_display_card_pressed(card: InventoryCard) -> void:
	cost_modifier_display.add_cost_modifier(card.card_id, card.cost_modifier)

func _on_cost_modifier_display_cost_changed(card_id: int, cost_modifier: int) -> void:
	for child in card_index_display.card_grid.get_children():
		if child is not InventoryCard:
			continue
		child = child as InventoryCard
		if child.card_id == card_id:
			child.cost_modifier = cost_modifier
			child._update_cost_modifier_label()


func _on_save_button_pressed() -> void:
	var cost_modifiers: Dictionary = cost_modifier_display.get_cost_modifiers()
	save.emit(cost_modifiers)

func _on_close_button_pressed() -> void:
	close.emit()
