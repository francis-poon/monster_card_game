class_name PlayerBoard
extends Control

signal player_ended_turn
signal player_died

var MAX_HEALTH: int = 5

@export var card_hand: CardHand
@export var card_scene: PackedScene
@export var play_field: PlayField
@export var health_bar: TiledProgressBar
@export var end_turn_button: Button

var health: int:
	set(value):
		health = value
		health_bar.value = value
var deck: PlayableDeck = PlayableDeck.new()

func start_game(p_deck: PlayableDeck, start_hand_size: int):
	deck = p_deck
	health_bar.max_value = MAX_HEALTH
	health = 5
	end_turn_button.disabled = false
	card_hand.clear()
	play_field.clear()
	draw_cards(start_hand_size)

func end_game():
	end_turn_button.disabled = true

func start_turn():
	draw_cards(1)
	end_turn_button.disabled = false

func end_turn():
	if get_card_value() != -1:
		deck.discard(get_card_value())
	play_field.clear()

func get_card_value() -> int:
	if play_field.can_play():
		return play_field.field_card.card_value
	return -1

func draw_cards(draw_count: int):
	for c in range(draw_count):
		var new_card: DraggableCard = card_scene.instantiate()
		new_card = new_card.construct(deck.draw())
		card_hand.add_card(new_card)

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		player_died.emit()

func _on_end_turn_button_pressed() -> void:
	if play_field.can_play():
		end_turn_button.disabled = true
		player_ended_turn.emit()
