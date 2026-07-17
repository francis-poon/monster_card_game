class_name TamedMonsterData
extends MonsterData

@export var nickname: String = ""
@export var uid: String = "-1"
@export var untamed_deck: DeckData = DeckData.new()

func _init(p_monster_id: int = -1, p_deck: DeckData = DeckData.new(), p_name: String = "",
	p_deck_size: int = 0, p_starting_hand_size: int = 0, p_draw_size: int = 0,
	p_max_health: int = 0, p_deck_cost_capacity: int = 0, p_card_cost_modifiers: Dictionary = {},
	p_nickname: String = "", p_uid: String = "-1", p_untamed_deck: DeckData = DeckData.new()) -> void:
		super._init(p_monster_id, p_deck, p_name, p_deck_size, p_starting_hand_size,
		p_draw_size, p_max_health, p_deck_cost_capacity, p_card_cost_modifiers)
		nickname = p_nickname
		uid = p_uid
		untamed_deck = p_untamed_deck
