class_name CardData
extends Resource

enum CardType {
	NULL,
	ATTACK,
	HEAL,
	ARMOR,
	SHIELD,
	DRAW
}

@export var card_id: int = 0
@export var card_type: CardType = CardType.NULL
@export var modifier: int = 0
@export var cost: int = 0

func _init(p_card_id: int = 0, p_card_type: CardType = CardType.NULL,
p_modifier: int = 0, p_cost: int = 0):
	card_id = p_card_id
	card_type = p_card_type
	modifier = p_modifier
	cost = p_cost
