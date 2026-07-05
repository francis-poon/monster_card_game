
class_name WildMonsterData
extends MonsterData

@export var drop_table: Array

func _init(p_monster_id: int = -1, p_deck: DeckData = DeckData.new(), p_name: String = "",
	p_deck_size: int = 0, p_starting_hand_size: int = 0, p_draw_size: int = 0,
	p_max_health: int = 0, p_drop_table: Array = []) -> void:
		super._init(p_monster_id, p_deck, p_name, p_deck_size, p_starting_hand_size, p_draw_size,
		p_max_health)
		drop_table = p_drop_table

func to_tamed_monster_data(nickname: String) -> TamedMonsterData:
	return TamedMonsterData.new(monster_id, deck.duplicate(), name, deck_size,
	starting_hand_size, draw_size, max_health, nickname, Globals.create_tamed_id())
