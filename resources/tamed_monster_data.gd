class_name TamedMonsterData
extends MonsterData

@export var nickname: String = ""
@export var uid: String = "-1"

func _init(p_monster_id: int = -1, p_deck: DeckData = DeckData.new(), p_name: String = "",
	p_deck_size: int = 0, p_starting_hand_size: int = 0, p_draw_size: int = 0,
	p_max_health: int = 0, p_nickname: String = "", p_uid: String = "-1") -> void:
		super._init(p_monster_id, p_deck, p_name, p_deck_size, p_starting_hand_size, p_draw_size,
		p_max_health)
		nickname = p_nickname
		uid = p_uid
