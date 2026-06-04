class_name CardGame
extends Control

@export var player_board: PlayerBoard
@export var opponent_board: OpponentBoard
@export var game_over_screen: Control
@export var victory_screen: Control
@export var play_button: Button

var test_threshold_val: int = 4

func new_game():
	game_over_screen.hide()
	victory_screen.hide()
	player_board.start_game(3)
	opponent_board.start_game(3)
	opponent_board.play_round()
	play_button.hide()

func _end_turn():
	opponent_board.end_turn()
	var player_card_value: int = player_board.get_card_value()
	var opponent_card_value: int = opponent_board.get_card_value()
	await get_tree().create_timer(1).timeout
	if player_card_value < opponent_card_value:
		player_board.take_damage(1)
	elif opponent_card_value < player_card_value:
		opponent_board.take_damage(1)

func _new_turn():
	opponent_board.start_turn()
	player_board.start_turn()


func _on_player_board_player_died() -> void:
	player_board.end_game()
	game_over_screen.show()
	play_button.show()


func _on_opponent_board_opponent_died() -> void:
	player_board.end_game()
	victory_screen.show()
	play_button.show()


func _on_play_button_pressed() -> void:
	new_game()


func _on_player_board_player_ended_turn() -> void:
	await _end_turn()
	_new_turn()
