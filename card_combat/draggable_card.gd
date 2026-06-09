class_name DraggableCard
extends MarginContainer

signal card_dropped(card: DraggableCard)

@export var face: TextureRect
@export var front_texture: Texture2D
@export var back_texture: Texture2D
@export var value_label: Label

var is_revealed: bool = true:
	set(p_value):
		is_revealed = p_value
		_update_card_face()
var is_draggable: bool = true

var card_value: int:
	set(value):
		card_value = value
		value_label.text = str(value)

func construct(p_is_revealed: bool = true, p_is_draggable: bool = true) -> DraggableCard:
	is_revealed = p_is_revealed
	is_draggable = p_is_draggable
	return self

func _ready() -> void:
	card_value = randi_range(1, 10)
	_update_card_face()

func reveal_card():
	is_revealed = true

func hide_card():
	is_revealed = false

func _update_card_face():
	if is_revealed:
		face.texture = front_texture
		value_label.show()
	else:
		face.texture = back_texture
		value_label.hide()

func get_preview() -> Control:
	var preview_card: MarginContainer = MarginContainer.new()
	preview_card.custom_minimum_size = self.size
	preview_card.add_child(face.duplicate())
	preview_card.add_child(value_label.duplicate())
	return preview_card

func _get_drag_data(at_position: Vector2) -> Variant:
	if not is_draggable:
		return null
	set_drag_preview(get_preview())
	return self
