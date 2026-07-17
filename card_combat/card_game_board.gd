class_name CardGameBoard
extends Control

signal ended_turn
signal died
signal attack(damage: int)

@export var card_hand: CardHand
@export var card_scene: PackedScene
@export var play_field: PlayField
@export var health_ui: HealthUI
@export var armor_value_label: Label
@export var shield_value_label: Label
@export var monster_sprite_base: TextureRect
@export var monster_sprite_color_mask: TextureRect
@export var name_label: Label

var max_health: int:
	set(value):
		max_health = value
		health_ui.max_health = max_health
var health: int:
	set(value):
		health = value
		health_ui.health = value
var shield: int:
	set(value):
		shield = value
		shield_value_label.text = str(value)
var armor: int:
	set(value):
		armor = value
		armor_value_label.text = str(value)
var deck: PlayableDeck = PlayableDeck.new()
var draw_size: int
var is_first_turn: bool

func start_game(p_monster_data: MonsterData):
	deck = PlayableDeck.new(p_monster_data.deck)
	deck.shuffle()
	is_first_turn = true
	max_health = p_monster_data.max_health
	health = max_health
	shield = 0
	armor = 0
	card_hand.clear()
	if not play_field.play_card.is_connected(_on_play_field_play_card):
		play_field.play_card.connect(_on_play_field_play_card)
	draw_size = p_monster_data.draw_size
	draw_cards(p_monster_data.starting_hand_size)
	monster_sprite_base.texture = ResourceLoader.load(Globals.get_sprite_base_path(p_monster_data.monster_id))
	monster_sprite_color_mask.texture = ResourceLoader.load(Globals.get_sprite_color_mask_path(p_monster_data.monster_id))

func end_game():
	pass

func start_turn():
	shield = 0
	if not is_first_turn:
		draw_cards(draw_size)
	is_first_turn = false

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
	if shield > 0:
		if shield >= remaining_damage:
			shield -= remaining_damage
			return
		remaining_damage -= shield
		shield = 0
	
	if armor > 0:
		if randi_range(1, remaining_damage + 2*armor) <= remaining_damage:
			remaining_damage -= armor
			armor = 0
		else:
			remaining_damage -= armor
		if remaining_damage <= 0:
			return
	
	health -= remaining_damage
	if health <= 0:
		died.emit()

func heal(heal_value: int):
	health += heal_value
	if health > max_health:
		health = max_health

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
