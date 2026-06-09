extends Node2D

@export var card_game: CardGame
@export var overworld: Overworld
@export var kill_count_label: Label

var kill_count: int:
	set(value):
		kill_count = value
		kill_count_label.text = "Monsters Killed: " + str(value)

func _ready():
	kill_count = 0
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED


func _on_overworld_start_battle() -> void:
	_start_battle()


func _start_battle():
	kill_count_label.hide()
	overworld.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	card_game.show()
	card_game.process_mode = Node.PROCESS_MODE_INHERIT
	card_game.new_game()

func _end_battle():
	print("Ending Battle")
	overworld.remove_monster()
	overworld.process_mode = Node.PROCESS_MODE_INHERIT
	card_game.hide()
	card_game.process_mode = Node.PROCESS_MODE_DISABLED
	kill_count_label.show()

func _on_card_game_battle_result(result: bool) -> void:
	if result:
		kill_count += 1
	_end_battle()
