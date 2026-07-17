class_name DTMonsterIndexSelector
extends Control

signal edit_monster_deck(monster: WildMonsterData)
signal edit_monster_cost_modifiers(monster: WildMonsterData)
signal close

@export var index_monster_display_scene: PackedScene

@export var monster_display_card_container: DTMonsterDisplayCardContainer
@export var deck_display: DeckDisplay

var button_group: ButtonGroup
var selected_display_card: DTIndexMonsterDisplay:
	set(value):
		selected_display_card = value
		if value != null:
			deck_display.load_deck_data(value.index_monster_data.deck, value.index_monster_data.card_cost_modifiers)

func _ready():
	if not get_tree().root.get_child(1) == self or not Globals.developer_mode:
		return
	print("Tamed Monster Selector running in developer mode")
	load_monsters(Globals.monster_index.keys())

func load_monsters(monster_index: Array):
	clear_monsters()
	deck_display.clear_cards()
	button_group = ButtonGroup.new()
	for monster_id in monster_index:
		var monster: WildMonsterData = Globals.get_monster(monster_id)
		var display_card: DTIndexMonsterDisplay = index_monster_display_scene.instantiate().construct(monster, button_group)
		monster_display_card_container.add_child(display_card)
		display_card.pressed.connect(_on_index_monster_display_pressed)

func clear_monsters():
	for child in monster_display_card_container.get_children():
		monster_display_card_container.remove_child(child)
		child.queue_free()

func get_selected_monster() -> WildMonsterData:
	if not button_group or not selected_display_card:
		return null
	return selected_display_card.index_monster_data

func redraw_deck_display():
	if selected_display_card:
		deck_display.load_deck_data(selected_display_card.index_monster_data.deck, selected_display_card.index_monster_data.card_cost_modifiers)
	else:
		deck_display.clear_cards()

func _on_index_monster_display_pressed(index_monster_display_scene: DTIndexMonsterDisplay):
	selected_display_card = index_monster_display_scene


func _on_edit_deck_button_pressed() -> void:
	if not button_group or not selected_display_card:
		return
	edit_monster_deck.emit(selected_display_card.index_monster_data)


func _on_edit_cost_modifier_button_pressed() -> void:
	if not button_group or not selected_display_card:
		return
	edit_monster_cost_modifiers.emit(selected_display_card.index_monster_data)

func _on_close_button_pressed() -> void:
	close.emit()
