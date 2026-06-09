@tool

class_name ProgressTile
extends MarginContainer

@export var _under_texture: TextureRect
@export var _fill_texture: TextureRect

func set_under_texture(texture: Texture2D):
	_under_texture.texture = texture

func set_fill_texture(texture: Texture2D):
	_fill_texture.texture = texture

func fill():
	_fill_texture.show()

func empty():
	_fill_texture.hide()
