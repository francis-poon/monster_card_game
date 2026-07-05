class_name TamedMonsterDisplayCard
extends Control

signal pressed(tamed_monster_display_card: TamedMonsterDisplayCard)

@export var card_button: Button
@export var monster_sprite_base: TextureRect
@export var monster_sprite_color_mask: TextureRect

var tamed_monster_data: TamedMonsterData
var sprite_scale: Vector2 = Vector2(4.0, 4.0)

var is_dragging: bool = false

func construct(p_tamed_monster_data: TamedMonsterData, p_button_group: ButtonGroup) -> TamedMonsterDisplayCard:
	tamed_monster_data = p_tamed_monster_data
	card_button.button_group = p_button_group
	var monster_id: int = p_tamed_monster_data.monster_id
	monster_sprite_base.texture = Globals.get_sprite_base_texture(monster_id)
	monster_sprite_color_mask.texture = Globals.get_sprite_color_mask_texture(monster_id)
	monster_sprite_base.scale = sprite_scale
	monster_sprite_color_mask.scale = sprite_scale
	return self


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_DRAG_BEGIN:
			if get_viewport().gui_get_drag_data() == self:
				is_dragging = true
				modulate = Color.TRANSPARENT
		NOTIFICATION_DRAG_END:
			if is_dragging:
				visible = true
				modulate = Color.WHITE

func _get_drag_data(at_position: Vector2) -> Variant:
	set_drag_preview(self.duplicate())
	return self

func _on_card_button_pressed() -> void:
	pressed.emit(self)
