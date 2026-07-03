extends Node2D

@export var card_game: CardGame
@export var overworld: Overworld
@export var kill_count_label: Label
@export var deck_editor: DeckEditor
@export var open_deck_editor_button: Button

var player_deck: PlayableDeck
var monster_deck: PlayableDeck
var inventory: DeckData
var kill_count: int:
	set(value):
		kill_count = value
		kill_count_label.text = "Monsters Killed: " + str(value)

func _ready():
	kill_count = 0
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED
	deck_editor.hide()
	player_deck = PlayableDeck.new(ResourceLoader.load("res://resources/player_deck.tres"))
	monster_deck = PlayableDeck.new(ResourceLoader.load("res://resources/monster_deck.tres"))
	inventory = ResourceLoader.load("res://resources/inventory.tres")
	#inventory.cards = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,11,1,1,1,1,1,1,1,11,1,1,1,1]


func _on_overworld_start_battle() -> void:
	_start_battle()


func _start_battle():
	kill_count_label.hide()
	overworld.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	card_game.show()
	card_game.process_mode = Node.PROCESS_MODE_INHERIT
	card_game.new_game(player_deck, monster_deck)

func _end_battle():
	print("Ending Battle")
	overworld.remove_monster()
	overworld.process_mode = Node.PROCESS_MODE_INHERIT
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED
	kill_count_label.show()

func _on_card_game_battle_result(result: bool, drops: Array) -> void:
	if result:
		kill_count += 1
		inventory.cards.append_array(drops)
	_end_battle()


func _on_deck_editor_close() -> void:
	deck_editor.hide()
	open_deck_editor_button.show()
	overworld.process_mode = Node.PROCESS_MODE_INHERIT


func _on_open_deck_editor_button_pressed() -> void:
	open_deck_editor_button.hide()
	deck_editor.load_deck(inventory, player_deck.deck_data)
	deck_editor.show()
	overworld.process_mode = Node.PROCESS_MODE_DISABLED
