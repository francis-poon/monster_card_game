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
	opponent_board.play_round()

func _end_turn():
	opponent_board.reveal_turn()
	var player_card_value: int = player_board.get_card_value()
	var opponent_card_value: int = opponent_board.get_card_value()
	await get_tree().create_timer(1).timeout
	if player_card_value < opponent_card_value:
		player_board.take_damage(1)
	elif opponent_card_value < player_card_value:
		opponent_board.take_damage(1)
	
	opponent_board.end_turn()
	player_board.end_turn()

func _new_turn():
	opponent_board.start_turn()
	player_board.start_turn()


func _on_player_board_player_died() -> void:
	player_board.end_game()
	drops_display.hide()
	game_over_label.text = "DEFEAT"
	game_over_screen.show()
	await get_tree().create_timer(2).timeout
	battle_result.emit(false, [])


func _on_opponent_board_opponent_died() -> void:
	var card_drop_val: int = randi_range(1,10)
	player_board.end_game()
	game_over_label.text = "VICTORY"
	for child in drops_container.get_children():
		child.queue_free()
	var card_drop: DraggableCard = draggable_card_scene.instantiate()
	card_drop = card_drop.construct(card_drop_val, true, false)
	drops_container.add_child(card_drop)
	game_over_screen.show()
	await get_tree().create_timer(2).timeout
	battle_result.emit(true, [card_drop_val])


func _on_player_board_player_ended_turn() -> void:
	await _end_turn()
	_new_turn()
