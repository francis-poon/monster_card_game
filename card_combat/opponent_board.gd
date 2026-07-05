class_name OpponentBoard
extends CardGameBoard

@export var hand_card_count_label: Label

var drop_table: Array

func start_game(p_monster_data: MonsterData):
	assert(p_monster_data is WildMonsterData, "Wild monster type is incorrect.")
	super.start_game(p_monster_data)
	drop_table = p_monster_data.drop_table
	monster_sprite_color_mask.modulate = Globals.wild_monster_color
	name_label.text = p_monster_data.name

func end_game():
	super.end_game()

func start_turn():
	super.start_turn()
	play_round()

func end_turn():
	super.end_turn()

func play_round():
	var number_of_cards_to_play: int = randi_range(1, card_hand.size())
	for c in range(number_of_cards_to_play):
		play_field.add_card(card_hand.play_random_card())
		await get_tree().create_timer(1).timeout
	end_turn()

func draw_cards(draw_count: int):
	super.draw_cards(draw_count)

func roll_drop_table() -> Array:
	return [drop_table.pick_random()]

func take_damage(damage: int):
	super.take_damage(damage)

func heal(heal_value: int):
	super.heal(heal_value)

func set_shield(shield_value: int):
	super.set_shield(shield_value)

func set_armor(armor_value: int):
	super.set_armor(armor_value)

func _on_play_field_play_card(card: CardData) -> void:
	super._on_play_field_play_card(card)


func _on_card_hand_count_changed(count: int) -> void:
	hand_card_count_label.text = str(count)
