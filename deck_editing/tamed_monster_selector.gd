class_name TamedMonsterSelector
extends Control

signal edit_tamed_monster(tamed_monster: TamedMonsterData)
signal close

@export var tamed_monster_display_card_scene: PackedScene

@export var monster_display_card_container: MonsterDisplayCardContainer
@export var monster_name_label: Label
@export var monster_type_label: Label
@export var monster_stats_label: Label
@export var monster_cost_modifier_label: Label
@export var deck_display: DeckDisplay

var button_group: ButtonGroup
var selected_display_card: TamedMonsterDisplayCard:
	set(value):
		selected_display_card = value
		if value != null:
			_populate_info_box(value.tamed_monster_data)
			deck_display.load_deck_data(value.tamed_monster_data.deck, value.tamed_monster_data.card_cost_modifiers)

func _ready():
	if not get_tree().root.get_child(1) == self or not Globals.developer_mode:
		return
	print("Tamed Monster Selector running in developer mode")
	load_monsters(Globals.player_party)

func load_monsters(player_party: PlayerPartyData):
	clear_monsters()
	monster_name_label.text = ""
	monster_type_label.text = ""
	monster_stats_label.text = ""
	monster_cost_modifier_label.text = ""
	deck_display.clear_cards()
	button_group = ButtonGroup.new()
	for party_monster_uid in player_party.party_uids:
		var monster: TamedMonsterData = Globals.get_tamed_monster(party_monster_uid)
		var display_card: TamedMonsterDisplayCard = tamed_monster_display_card_scene.instantiate().construct(monster, button_group)
		monster_display_card_container.add_child(display_card)
		display_card.pressed.connect(_on_tamed_monster_display_card_pressed)

func clear_monsters():
	for child in monster_display_card_container.get_children():
		monster_display_card_container.remove_child(child)
		child.queue_free()

func get_selected_monster() -> TamedMonsterData:
	if not button_group or not selected_display_card:
		return null
	return selected_display_card.tamed_monster_data

func get_party_order() -> PlayerPartyData:
	return PlayerPartyData.new(monster_display_card_container.get_monster_list())

func redraw_deck_display():
	if selected_display_card:
		deck_display.load_deck_data(selected_display_card.tamed_monster_data.deck, selected_display_card.tamed_monster_data.card_cost_modifiers)
	else:
		deck_display.clear_cards()

func _populate_info_box(tamed_monster_data: TamedMonsterData):
	monster_name_label.text = tamed_monster_data.nickname
	monster_type_label.text = tamed_monster_data.name
	monster_stats_label.text = "HP: {0}/{0}\nStarting Hand: {1}\nDraw Size: {2}\nDeck Size: {3}".format(
		[tamed_monster_data.max_health,
		tamed_monster_data.starting_hand_size,
		tamed_monster_data.draw_size,
		tamed_monster_data.deck_size])
	monster_cost_modifier_label.text = "Cost Modifiers:\n"
	for card_id in tamed_monster_data.card_cost_modifiers:
		var card_data:CardData = Globals.get_card(card_id)
		monster_cost_modifier_label.text += "{0}: {1} {2}\n".format([
			"%3d" % tamed_monster_data.card_cost_modifiers[card_id],
			CardData.CardType.keys()[Globals.get_card(card_id).card_type],
			Globals.get_card(card_id).modifier
		])

func _on_tamed_monster_display_card_pressed(tamed_monster_display_card: TamedMonsterDisplayCard):
	selected_display_card = tamed_monster_display_card

func _on_edit_button_pressed() -> void:
	if not button_group or not selected_display_card:
		return
	edit_tamed_monster.emit(selected_display_card.tamed_monster_data)


func _on_close_button_pressed() -> void:
	close.emit()
