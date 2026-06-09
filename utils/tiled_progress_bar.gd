@tool

class_name TiledProgressBar
extends HBoxContainer

var _progress_tile_scene: PackedScene = preload("res://utils/progress_tile.tscn")

@export var under_texture: Texture2D:
	set(p_value):
		under_texture = p_value
		for tile in tiles:
			(tile as ProgressTile).set_under_texture(p_value)
@export var fill_texture: Texture2D:
	set(p_value):
		fill_texture = p_value
		for tile in tiles:
			(tile as ProgressTile).set_fill_texture(p_value)
@export var value: int:
	set(p_value):
		value = p_value
		for i in range(0, tiles.size()):
			if i < value:
				(tiles[i] as ProgressTile).fill()
			else:
				(tiles[i] as ProgressTile).empty()
@export var max_value: int:
	set(p_value):
		max_value = p_value
		if p_value > tiles.size():
			var old_size: int = tiles.size()
			tiles.resize(p_value)
			for i in range(old_size, tiles.size()):
				var new_tile: ProgressTile = _progress_tile_scene.instantiate()
				tiles[i] = new_tile
				add_child(new_tile)
				new_tile.set_under_texture(under_texture)
				new_tile.set_fill_texture(fill_texture)
				if i < value:
					new_tile.fill()
				else:
					new_tile.empty()
		elif p_value < tiles.size():
			for i in range(p_value, tiles.size()):
				remove_child(tiles[i])
				tiles[i].queue_free()
			tiles.resize(p_value)

var tiles: Array = []

func _ready() -> void:
	for child in get_children():
		child.queue_free()
	tiles = []
	tiles.resize(max_value)
	for i in range(0, tiles.size()):
		var new_tile: ProgressTile = _progress_tile_scene.instantiate()
		tiles[i] = new_tile
		add_child(new_tile)
		new_tile.set_under_texture(under_texture)
		new_tile.set_fill_texture(fill_texture)
		if i < value:
			new_tile.fill()
		else:
			new_tile.empty()
