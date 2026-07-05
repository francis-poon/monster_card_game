class_name CardGame
extends Control

signal battle_result(result: bool, drops: Array, tamed_monster: TamedMonsterData)

@export var player_board: PlayerBoard
@export var opponent_board: OpponentBoard
@export var game_over_screen: GameOverScreen
@export var draggable_card_scene: PackedScene

var wild_monster: WildMonsterData

func _ready():
	if not get_tree().root.get_child(1) == self:
		return
	print("Card game running in test mode")
	var player_monster_data: TamedMonsterData = ResourceLoader.load("res://resources/tamed_monsters/player_monster_data.tres")
	var opponent_monster_data: WildMonsterData = ResourceLoader.load("res://resources/monster_index/monster_001.tres")
	new_game(player_monster_data, opponent_monster_data)

func new_game(p_player_mosnter: TamedMonsterData, p_opponent_monster: WildMonsterData):
	wild_monster = p_opponent_monster
	game_over_screen.hide()
	player_board.start_game(p_player_mosnter)
	opponent_board.start_game(p_opponent_monster)
	player_board.start_turn()


func _on_player_board_ended_turn() -> void:
	opponent_board.start_turn()

func _on_player_board_attack(damage: int) -> void:
	opponent_board.take_damage(damage)

func _on_player_board_died() -> void:
	player_board.end_game()
	game_over_screen.defeat()
	await get_tree().create_timer(2).timeout
	battle_result.emit(false, [], null)


func _on_opponent_board_ended_turn() -> void:
	player_board.start_turn()

func _on_opponent_board_attack(damage: int) -> void:
	player_board.take_damage(damage)

func _on_opponent_board_died() -> void:
	var card_drop_val: int = opponent_board.roll_drop_table()[0]
	player_board.end_game()
	game_over_screen.victory()


func _on_drops_button_pressed() -> void:
	var drops: Array = opponent_board.roll_drop_table()
	game_over_screen.display_drops(drops)
	await get_tree().create_timer(2).timeout
	battle_result.emit(true, drops, null)

func _on_capture_button_pressed() -> void:
	game_over_screen.display_capture(wild_monster)


func _on_game_over_screen_submit_nickname(nickname: String) -> void:
	var tamed_monster: TamedMonsterData = wild_monster.to_tamed_monster_data(nickname)
	battle_result.emit(true, [], tamed_monster)


func _on_player_board_run() -> void:
	player_board.end_game()
	game_over_screen.run()
	await get_tree().create_timer(2).timeout
	battle_result.emit(false, [], null)
