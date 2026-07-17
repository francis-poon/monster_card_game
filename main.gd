extends Node2D

@export var card_game: CardGame
@export var overworld: Overworld
@export var kill_count_label: Label
@export var deck_editor: DeckEditor
@export var open_tamed_monster_selector_button: Button
@export var tamed_monster_selector: TamedMonsterSelector
@export var combat_cooldown_timer: Timer

var inventory: DeckData
var kill_count: int:
	set(value):
		kill_count = value
		kill_count_label.text = "Monsters Killed: " + str(value)
var is_combat_cooldown: bool

func _ready():
	Globals.init_save_dir()
	kill_count = 0
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED
	deck_editor.hide()
	tamed_monster_selector.hide()
	open_tamed_monster_selector_button.show()
	inventory = Globals.load_inventory()
	is_combat_cooldown = false
	
	if Globals.player_party.party_uids.size() <= 0:
		Globals.load_starter()
	
	var player: PlayerCharacter = get_tree().get_first_node_in_group("player")
	player.load_monster_sprite(Globals.get_tamed_monster(Globals.player_party.party_uids[0]).monster_id)


func _on_overworld_start_battle(monster: MonsterCharacter) -> void:
	_start_battle(monster.monster_data)


func _start_battle(monster_data: WildMonsterData):
	if is_combat_cooldown:
		return
	is_combat_cooldown = true
	combat_cooldown_timer.start()
	combat_cooldown_timer.process_mode = Node.PROCESS_MODE_DISABLED
	kill_count_label.hide()
	open_tamed_monster_selector_button.hide()
	overworld.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	card_game.show()
	card_game.process_mode = Node.PROCESS_MODE_INHERIT
	var player_monster: TamedMonsterData = Globals.get_tamed_monster(Globals.player_party.party_uids[0])
	card_game.new_game(player_monster, monster_data)

func _end_battle():
	print("Ending Battle")
	combat_cooldown_timer.process_mode = Node.PROCESS_MODE_INHERIT
	overworld.remove_monster()
	overworld.process_mode = Node.PROCESS_MODE_INHERIT
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED
	kill_count_label.show()
	open_tamed_monster_selector_button.show()
	overworld.reset_player_input()

func _on_card_game_battle_result(result: bool, drops: Array, tamed_monster: TamedMonsterData) -> void:
	if result:
		kill_count += 1
		inventory.cards.append_array(drops)
		Globals.save_inventory(inventory)
		if tamed_monster:
			Globals.add_tamed_monster(tamed_monster)
			Globals.save_tamed_monster(tamed_monster)
	_end_battle()

func _on_deck_editor_save(p_inventory: DeckData, p_untamed_deck: DeckData, p_deck: DeckData) -> void:
	inventory = p_inventory
	var tamed_monster: TamedMonsterData = tamed_monster_selector.get_selected_monster()
	tamed_monster.deck = p_deck
	tamed_monster.untamed_deck = p_untamed_deck
	Globals.save_tamed_monster(tamed_monster)
	Globals.save_inventory(inventory)
	

func _on_deck_editor_close() -> void:
	deck_editor.hide()
	tamed_monster_selector.show()
	tamed_monster_selector.redraw_deck_display()


func _on_tamed_monster_selector_edit_tamed_monster(tamed_monster: TamedMonsterData) -> void:
	tamed_monster_selector.hide()
	deck_editor.load_deck(
		inventory,
		tamed_monster.untamed_deck,
		tamed_monster.deck,
		tamed_monster.deck_size,
		tamed_monster.deck_cost_capacity,
		tamed_monster.card_cost_modifiers)
	deck_editor.show()


func _on_open_tamed_monster_selector_button_pressed() -> void:
	open_tamed_monster_selector_button.hide()
	tamed_monster_selector.load_monsters(Globals.player_party)
	tamed_monster_selector.show()
	overworld.process_mode = Node.PROCESS_MODE_DISABLED


func _on_tamed_monster_selector_close() -> void:
	open_tamed_monster_selector_button.show()
	tamed_monster_selector.hide()
	overworld.process_mode = Node.PROCESS_MODE_INHERIT
	var updated_party: PlayerPartyData = tamed_monster_selector.get_party_order()
	Globals.update_player_party(updated_party)
	var player: PlayerCharacter = get_tree().get_first_node_in_group("player")
	player.load_monster_sprite(Globals.get_tamed_monster(updated_party.party_uids[0]).monster_id)


func _on_combat_cooldown_timer_timeout() -> void:
	print("timer_ended")
	is_combat_cooldown = false
