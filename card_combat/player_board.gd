class_name PlayerBoard
extends CardGameBoard

signal run

@export var end_turn_button: Button
@export var run_button: Button


func start_game(p_monster_data: MonsterData):
	assert(p_monster_data is TamedMonsterData, "Player monster is incorrect type.")
	super.start_game(p_monster_data)
	end_turn_button.disabled = false
	run_button.disabled = false
	monster_sprite_color_mask.modulate = Globals.tamed_monster_color
	name_label.text = p_monster_data.nickname


func end_game():
	super.end_game()
	end_turn_button.disabled = true
	run_button.disabled = true

func start_turn():
	super.start_turn()
	end_turn_button.disabled = false
	run_button.disabled = false

func end_turn():
	super.end_turn()
	end_turn_button.disabled = true
	run_button.disabled = true

func _on_end_turn_button_pressed() -> void:
	end_turn()


func _on_run_button_pressed() -> void:
	run.emit()
