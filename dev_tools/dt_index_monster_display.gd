class_name DTIndexMonsterDisplay
extends Control


signal pressed(index_monster_display: DTIndexMonsterDisplay)

@export var card_button: Button
@export var monster_sprite_base: TextureRect
@export var monster_sprite_color_mask: TextureRect
@export var type_label: Label

var index_monster_data: WildMonsterData

var is_dragging: bool = false

func construct(p_index_monster_data: WildMonsterData, p_button_group: ButtonGroup) -> DTIndexMonsterDisplay:
	index_monster_data = p_index_monster_data
	card_button.button_group = p_button_group
	var monster_id: int = p_index_monster_data.monster_id
	monster_sprite_base.texture = Globals.get_sprite_base_texture(monster_id)
	monster_sprite_color_mask.texture = Globals.get_sprite_color_mask_texture(monster_id)
	type_label.text = Globals.get_monster(monster_id).name
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


func _on_display_button_pressed() -> void:
	pressed.emit(self)
