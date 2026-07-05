class_name MonsterData
extends Resource

@export var monster_id: int = -1
@export var deck: DeckData = DeckData.new()
@export var name: String = ""
@export var deck_size: int = 0
@export var starting_hand_size: int = 0
@export var draw_size: int = 0
@export var max_health: int = 0

func _init(p_monster_id: int = -1, p_deck: DeckData = DeckData.new(), p_name: String = "", p_deck_size: int = 0,
	p_starting_hand_size: int = 0, p_draw_size: int = 0, p_max_health: int = 0) -> void:
	monster_id = p_monster_id
	deck = p_deck
	name = p_name
	deck_size = p_deck_size
	starting_hand_size = p_starting_hand_size
	draw_size = p_draw_size
	max_health = p_max_health
