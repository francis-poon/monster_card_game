extends Node2D

@export var tool_selector: Control
@export var deck_editor: DTDeckEditor
@export var monster_index_selector: DTMonsterIndexSelector
@export var cost_modifier_editor: DTCostModifierEditor

func _ready():
	_hide_all()
	tool_selector.show()

func _on_monster_index_editor_button_pressed() -> void:
	_hide_all()
	monster_index_selector.load_monsters(Globals.monster_index.keys())
	monster_index_selector.show()

func _on_card_index_editor_button_pressed() -> void:
	pass # Replace with function body.

func _hide_all():
	tool_selector.hide()
	deck_editor.hide()
	monster_index_selector.hide()
	cost_modifier_editor.hide()


func _on_dt_deck_editor_close() -> void:
	_hide_all()
	monster_index_selector.redraw_deck_display()
	monster_index_selector.show()


func _on_dt_deck_editor_save(deck: DeckData) -> void:
	var index_monster: WildMonsterData = monster_index_selector.get_selected_monster()
	index_monster.deck = deck
	ResourceSaver.save(index_monster)


func _on_dt_monster_index_selector_close() -> void:
	_hide_all()
	tool_selector.show()

func _on_dt_monster_index_selector_edit_monster_deck(monster: WildMonsterData) -> void:
	_hide_all()
	deck_editor.load_deck(DeckData.new(Globals.card_index.keys()), monster.deck, monster.deck_size, monster.deck_cost_capacity, monster.card_cost_modifiers)
	deck_editor.show()


func _on_dt_monster_index_selector_edit_monster_cost_modifiers(monster: WildMonsterData) -> void:
	_hide_all()
	cost_modifier_editor.load_cost_modifiers(DeckData.new(Globals.card_index.keys()), monster.card_cost_modifiers)
	cost_modifier_editor.show()


func _on_dt_cost_modifier_editor_close() -> void:
	_hide_all()
	monster_index_selector.redraw_deck_display()
	monster_index_selector.show()


func _on_dt_cost_modifier_editor_save(cost_modifiers: Dictionary) -> void:
	var index_monster: WildMonsterData = monster_index_selector.get_selected_monster()
	index_monster.card_cost_modifiers = cost_modifiers
	ResourceSaver.save(index_monster)
