class_name PlayerCharacter
extends CharacterBody2D


const SPEED = 100.0
var _input_vector: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity = _input_vector.normalized() * SPEED
	move_and_collide(velocity * delta)

func _unhandled_input(event: InputEvent):
	_input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		_input_vector.x += 1
	if Input.is_action_pressed("move_left"):
		_input_vector.x += -1
	
	if Input.is_action_pressed("move_up"):
		_input_vector.y += -1
	if Input.is_action_pressed("move_down"):
		_input_vector.y += 1
