class_name MonsterSpawner
extends Node2D

signal monster_encountered_player(monster: MonsterCharacter)

@export var monster_scene: PackedScene
@export var spawn_limit: int
@export var spawn_delay_timer: Timer
@export var spawn_delay: float
@export var monster_container: Node2D


var is_spawn_ready: bool
var spawn_queue: int
var is_spawning: bool

func _ready() -> void:
	spawn_delay_timer.wait_time = spawn_delay
	spawn_delay_timer.one_shot = true
	is_spawning = false
	if spawn_limit > 0:
		_spawn()
		queue(spawn_limit - 1)

func _spawn():
	print("Spawning monster")
	var monster: MonsterCharacter = monster_scene.instantiate()
	monster.died.connect(_on_monster_death)
	monster.encountered_player.connect(_on_monster_encountered_player)
	monster_container.add_child(monster)

func queue(count: int):
	spawn_queue += count
	if not is_spawning:
		run_spawn_queue()
	
func run_spawn_queue():
	if monster_container.get_child_count() >= spawn_limit:
		is_spawning = false
		spawn_queue = 0
		return
	is_spawning = true
	spawn_delay_timer.start()

func _on_monster_death(monster: MonsterCharacter):
	monster.died.disconnect(_on_monster_death)
	monster.encountered_player.disconnect(_on_monster_encountered_player)
	monster_container.remove_child(monster)
	monster.queue_free()
	queue(1)

func _on_monster_encountered_player(monster: MonsterCharacter):
	monster_encountered_player.emit(monster)

func _on_spawn_delay_timer_timeout() -> void:
	if monster_container.get_child_count() >= spawn_limit:
		is_spawning = false
		spawn_queue = 0
		return
	_spawn()
	spawn_delay_timer.start()
