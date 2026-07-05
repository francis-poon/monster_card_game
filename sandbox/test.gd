extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(Globals.monster_index)
	print(Globals.get_monster(0).name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
