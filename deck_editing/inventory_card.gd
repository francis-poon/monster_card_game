class_name InventoryCard
extends Control

signal card_pressed(card: InventoryCard)

@export var card_text: Label
@export var card_face_texture: TextureRect
@export var normal_card_face: Texture2D
@export var untamed_card_face: Texture2D
@export var cost_label: Label
@export var cost_label_backing: ColorRect
@export var reduced_cost_color: Color
@export var increased_cost_color: Color
@export var default_cost_color: Color

@export var card_id: int
@export var cost_modifier: int


func construct(p_card_id: int = 0, p_cost_modifier: int = 0) -> InventoryCard:
	card_id = p_card_id
	var card_data: CardData = Globals.get_card(card_id)
	card_text.text = "{0}\n{1}".format([CardData.CardType.keys()[card_data.card_type], card_data.modifier])
	card_face_texture.texture = normal_card_face if card_id > 0 else untamed_card_face
	cost_modifier = p_cost_modifier
	_update_cost_modifier_label()
	
	return self

func _update_cost_modifier_label():
	cost_label.text = str(Globals.get_card(card_id).cost + cost_modifier)
	if cost_modifier == 0:
		cost_label_backing.color = default_cost_color
	elif cost_modifier < 0:
		cost_label_backing.color = reduced_cost_color
	else:
		cost_label_backing.color = increased_cost_color

func _on_button_pressed() -> void:
	card_pressed.emit(self)
