class_name CardGame
extends Control

signal battle_result(result: bool, drops: Array)

@export var player_board: PlayerBoard
@export var opponent_board: OpponentBoard
@export var game_over_screen: Control
@export var game_over_label: Label
@export var drops_display: Control
@export var drops_container: HBoxContainer
@export var draggable_card_scene: PackedScene

func _ready():
	if not get_tree().root.get_child(1) == self:
		return
	print("Card game running in test mode")
	var player_deck_data = ResourceLoader.load("res://resources/player_deck.tres")
	var opponent_deck_data = ResourceLoader.load("res://resources/monster_deck.tres")
	new_game(PlayableDeck.new(player_deck_data), PlayableDeck.new(opponent_deck_data))

func new_game(p_player_deck: PlayableDeck, p_opponent_deck: PlayableDeck):
	game_over_screen.hide()
	player_board.start_game(p_player_deck, 3)
	opponent_board.start_game(p_opponent_deck, 3)
	player_board.start_turn()


func _on_player_board_ended_turn() -> void:
	opponent_board.start_turn()

func _on_player_board_attack(damage: int) -> void:
	opponent_board.take_damage(damage)

func _on_player_board_died() -> void:
	player_board.end_game()
	drops_display.hide()
	game_over_label.text = "DEFEAT"
	game_over_screen.show()
	await get_tree().create_timer(2).timeout
	battle_result.emit(false, [])


func _on_opponent_board_ended_turn() -> void:
	player_board.start_turn()

func _on_opponent_board_attack(damage: int) -> void:
	player_board.take_damage(damage)

func _on_opponent_board_died() -> void:
	var card_drop_val: int = randi_range(0,4)
	player_board.end_game()
	game_over_label.text = "VICTORY"
	for child in drops_container.get_children():
		child.queue_free()
	var card_drop: DraggableCard = draggable_card_scene.instantiate()
	card_drop = card_drop.construct(Globals.get_card(card_drop_val), true, false)
	drops_container.add_child(card_drop)
	game_over_screen.show()
	await get_tree().create_timer(2).timeout
	battle_result.emit(true, [card_drop_val])
