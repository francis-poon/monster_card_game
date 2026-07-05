class_name DraggableCard
extends MarginContainer

signal card_dropped(card: DraggableCard)

@export var face: TextureRect
@export var front_texture: Texture2D
@export var back_texture: Texture2D
@export var card_text: Label

var is_revealed: bool = true:
	set(p_value):
		is_revealed = p_value
		_update_card_face()
var is_draggable: bool = true

var card_data: CardData:
	set(value):
		card_data = value
		card_text.text = "{0}\n{1}".format([CardData.CardType.keys()[card_data.card_type], card_data.modifier])

func construct(p_card_data: CardData = CardData.new(), p_is_revealed: bool = true, p_is_draggable: bool = true) -> DraggableCard:
	card_data = p_card_data
	is_revealed = p_is_revealed
	is_draggable = p_is_draggable
	return self

func _ready() -> void:
	_update_card_face()

func reveal_card():
	is_revealed = true

func hide_card():
	is_revealed = false

func disable_drag():
	is_draggable = false

func enable_drag():
	is_draggable = true

func _update_card_face():
	if is_revealed:
		face.texture = front_texture
		card_text.show()
	else:
		face.texture = back_texture
		card_text.hide()

func get_preview() -> Control:
	var preview_card: MarginContainer = MarginContainer.new()
	preview_card.custom_minimum_size = self.size
	preview_card.add_child(face.duplicate())
	preview_card.add_child(card_text.duplicate())
	return preview_card

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not is_draggable:
		return null
	set_drag_preview(get_preview())
	return self
