class_name CardGameBoard
extends Control

signal ended_turn
signal died
signal attack(damage: int)

var MAX_HEALTH: int = 5

@export var card_hand: CardHand
@export var card_scene: PackedScene
@export var play_field: PlayField
@export var health_bar: TiledProgressBar
@export var armor_value_label: Label
@export var shield_value_label: Label

var health: int:
	set(value):
		health = value
		health_bar.value = value
var shield: int:
	set(value):
		shield = value
		shield_value_label.text = str(value)
var armor: int:
	set(value):
		armor = value
		armor_value_label.text = str(value)
var deck: PlayableDeck = PlayableDeck.new()


func start_game(p_deck: PlayableDeck, start_hand_size: int):
	deck = p_deck
	deck.shuffle()
	health_bar.max_value = MAX_HEALTH
	health = MAX_HEALTH
	shield = 0
	armor = 0
	card_hand.clear()
	play_field.play_card.connect(_on_play_field_play_card)
	draw_cards(start_hand_size)

func end_game():
	pass

func start_turn():
	shield = 0
	draw_cards(2)

func end_turn():
	ended_turn.emit()

func draw_cards(draw_count: int):
	for c in range(draw_count):
		if not deck.can_draw():
			return
		var new_card: DraggableCard = card_scene.instantiate()
		new_card = new_card.construct(Globals.get_card(deck.draw()))
		card_hand.add_card(new_card)

func take_damage(damage: int):
	var remaining_damage: int = damage
	if armor > 0:
		remaining_damage -= armor
		if randi_range(1, damage + 2*armor) <= damage:
			armor = 0
		if remaining_damage <= 0:
			return
	if shield > 0:
		if shield >= remaining_damage:
			shield -= remaining_damage
			return
		remaining_damage -= shield
		shield = 0
	health -= remaining_damage
	if health <= 0:
		died.emit()

func heal(heal_value: int):
	health += heal_value
	if health > MAX_HEALTH:
		health = MAX_HEALTH

func set_shield(shield_value: int):
	shield += shield_value

func set_armor(armor_value: int):
	if armor_value > armor:
		armor = armor_value


func _on_play_field_play_card(card: CardData) -> void:
	deck.discard(card.card_id)
	match card.card_type:
		CardData.CardType.ATTACK:
			attack.emit(card.modifier)
		CardData.CardType.HEAL:
			heal(card.modifier)
		CardData.CardType.ARMOR:
			set_armor(card.modifier)
		CardData.CardType.SHIELD:
			set_shield(card.modifier)
		CardData.CardType.DRAW:
			draw_cards(card.modifier)
