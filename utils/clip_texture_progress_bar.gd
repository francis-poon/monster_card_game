@tool

class_name ClipTextureProgressBar
extends MarginContainer

@export var under_texture: Texture2D:
	set(p_value):
		under_texture = p_value
		if under_texture_rect:
			under_texture_rect.texture = p_value
@export var progress_texture: Texture2D:
	set(p_value):
		progress_texture = p_value
		if progress_texture_rect:
			progress_texture_rect.texture = p_value
@export var over_texture: Texture2D:
	set(p_value):
		over_texture = p_value
		if over_texture_rect:
			over_texture_rect.texture = p_value

@export var expand_mode: TextureRect.ExpandMode = TextureRect.ExpandMode.EXPAND_KEEP_SIZE:
	set(p_value):
		expand_mode = p_value
		_update_expand_mode()
@export var stretch_mode: TextureRect.StretchMode = TextureRect.StretchMode.STRETCH_SCALE:
	set(p_value):
		stretch_mode = p_value
		_update_stretch_mode()

@export var fill_mode: ProgressBar.FillMode = ProgressBar.FillMode.FILL_BEGIN_TO_END:
	set(p_value):
		fill_mode = p_value
		_update_progress_bar()
@export var value: float = 100:
	set(p_value):
		value = p_value
		_update_progress_bar()
@export var max_value: float = 100:
	set(p_value):
		max_value = p_value
		_update_progress_bar()

var under_texture_rect: TextureRect
var progress_texture_rect: TextureRect
var over_texture_rect: TextureRect

func _ready() -> void:
	under_texture_rect = TextureRect.new()
	progress_texture_rect = TextureRect.new()
	over_texture_rect = TextureRect.new()
	
	add_child(under_texture_rect)
	under_texture_rect.add_child(progress_texture_rect)
	progress_texture_rect.set_anchors_preset(PRESET_FULL_RECT)
	add_child(over_texture_rect)
	
	under_texture_rect.texture = under_texture
	progress_texture_rect.texture = progress_texture
	over_texture_rect.texture = over_texture
	_update_expand_mode()
	_update_stretch_mode()
	_update_progress_bar()
	
	under_texture_rect.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

func _update_progress_bar():
	if not progress_texture_rect:
		return
	
	var position_delta: float = clamp(1.0 - (value / max_value), 0.0, 1.0)
	match fill_mode:
		ProgressBar.FILL_BEGIN_TO_END:
			position_delta *= self.size.x * -1.0
			progress_texture_rect.position = Vector2(position_delta, 0)
		ProgressBar.FILL_END_TO_BEGIN:
			position_delta *= self.size.x
			progress_texture_rect.position = Vector2(position_delta, 0)
		ProgressBar.FILL_BOTTOM_TO_TOP:
			position_delta *= self.size.y
			progress_texture_rect.position = Vector2(0, position_delta)
		ProgressBar.FILL_TOP_TO_BOTTOM:
			position_delta *= self.size.y * -1.0
			progress_texture_rect.position = Vector2(0, position_delta)

func _update_expand_mode():
	if not (under_texture_rect and progress_texture_rect and over_texture_rect):
		return
	under_texture_rect.expand_mode = expand_mode
	progress_texture_rect.expand_mode = expand_mode
	over_texture_rect.expand_mode = expand_mode

func _update_stretch_mode():
	if not (under_texture_rect and progress_texture_rect and over_texture_rect):
		return
	under_texture_rect.stretch_mode = stretch_mode
	progress_texture_rect.stretch_mode = stretch_mode
	over_texture_rect.stretch_mode = stretch_mode
