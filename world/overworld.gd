class_name Overworld
extends Node2D

signal start_battle(monster: MonsterCharacter)

@export var monster_spawner: MonsterSpawner
@export var player: PlayerCharacter

var active_monster: MonsterCharacter

func remove_monster():
	active_monster.kill()

func reset_player_input():
	player.reset_input()

func _monster_encountered_player(monster: MonsterCharacter) -> void:
	print("Player encountered monster")
	active_monster = monster
	start_battle.emit(monster)
