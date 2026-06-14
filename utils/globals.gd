extends Node

var developer_mode: bool = true

func get_save_dir_root() -> String:
	if developer_mode:
		return "res://saves/"
	else:
		return "user://saves/"
