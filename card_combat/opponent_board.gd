class_name OpponentBoard
extends Control

signal opponent_died

var MAX_HEALTH: int = 5

@export var card_hand: CardHand
@export var card_scene: PackedScene
@export var play_field: PlayField
@export var health_bar: TiledProgressBar

var health: int:
	set(value):
		health = value
		health_bar.value = value
var deck: PlayableDeck = PlayableDeck.new()

func start_game(p_deck: PlayableDeck, start_hand_size: int):
	deck = p_deck
	health_bar.max_value = MAX_HEALTH
	health = 5
	card_hand.clear()
	play_field.clear()
	draw_cards(start_hand_size)

func start_turn():
	draw_cards(1)
	play_round()

func reveal_turn():
	play_field.field_card.reveal_card()

func end_turn():
	if get_card_value() != -1:
		deck.discard(get_card_value())
	play_field.clear()

func draw_cards(draw_count: int):
	for c in range(draw_count):
		var new_card: DraggableCard = card_scene.instantiate()
		new_card = new_card.construct(deck.draw(), false, false)
		card_hand.add_card(new_card)

func play_round():
	play_field.add_card(card_hand.play_random_card())

func get_card_value() -> int:
	return play_field.field_card.card_value

func take_damage(damage: int):
	health -= damage
	if health <= 0:
		opponent_died.emit()
