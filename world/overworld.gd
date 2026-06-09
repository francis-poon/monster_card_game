class_name Overworld
extends Node2D

signal start_battle

@export var monster_spawner: MonsterSpawner

var active_monster: MonsterCharacter

func remove_monster():
	active_monster.kill()


func _monster_encountered_player(monster: MonsterCharacter) -> void:
	print("Player encountered monster")
	active_monster = monster
	start_battle.emit()
