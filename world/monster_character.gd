class_name MonsterCharacter
extends CharacterBody2D

signal encountered_player(monster: MonsterCharacter)
signal died(monster: MonsterCharacter)

const SPEED = 300.0
var target_a: Vector2
var target_b: Vector2
var move_vector: Vector2


func _ready():
	target_a = position + Vector2(10, 0)
	target_b = position - Vector2(10, 0)
	move_vector = Vector2(1,0)

func _physics_process(delta: float) -> void:
	if move_vector.x > 0 and position.x > target_a.x:
		move_vector = Vector2(-1, 0)
	elif move_vector.x < 0 and position.x < target_b.x:
		move_vector = Vector2(1, 0)
	velocity = move_vector * SPEED * delta
	move_and_slide()

func kill():
	died.emit(self)

func _on_detection_area_2d_body_entered(body: Node2D) -> void:
	if body is PlayerCharacter:
		encountered_player.emit(self)


func _on_detection_area_2d_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
