class_name DTCostModifierDisplay
extends Control

signal cost_changed(card_id: int, cost_modifier: int)

@export var cost_modifier_edit_line_scene: PackedScene

@export var edit_line_container: Container

func load_cost_modifiers(cost_modifiers: Dictionary):
	_clear_edit_line()
	for card_id in cost_modifiers:
		var edit_line: DTCostModifierEditLine = cost_modifier_edit_line_scene\
			.instantiate()\
			.construct(card_id, cost_modifiers[card_id])
		edit_line.cost_changed.connect(_on_edit_line_cost_changed)
		edit_line.remove.connect(_on_edit_line_remove)
		edit_line_container.add_child(edit_line)

func add_cost_modifier(p_card_id: int, p_cost_modifier: int):
	var edit_line: DTCostModifierEditLine = cost_modifier_edit_line_scene\
		.instantiate()\
		.construct(p_card_id, p_cost_modifier)
	edit_line.cost_changed.connect(_on_edit_line_cost_changed)
	edit_line.remove.connect(_on_edit_line_remove)
	edit_line_container.add_child(edit_line)

func get_cost_modifiers() -> Dictionary:
	var cost_modifiers: Dictionary = {}
	for child in edit_line_container.get_children():
		child = child as DTCostModifierEditLine
		cost_modifiers[child.card_id] = child.cost_modifier
	
	return cost_modifiers

func _remove_edit_line(edit_line: DTCostModifierEditLine):
	if edit_line.cost_changed.is_connected(_on_edit_line_cost_changed):
		edit_line.cost_changed.disconnect(_on_edit_line_cost_changed)
	
	if edit_line.remove.is_connected(_on_edit_line_remove):
		edit_line.remove.disconnect(_on_edit_line_remove)
	
	edit_line.queue_free()

func _clear_edit_line():
	for child in edit_line_container.get_children():
		_remove_edit_line(child)

func _on_edit_line_cost_changed(card_id: int, cost_modifier: int):
	cost_changed.emit(card_id, cost_modifier)

func _on_edit_line_remove(edit_line: DTCostModifierEditLine):
	cost_changed.emit(edit_line.card_id, 0)
	_remove_edit_line(edit_line)
	
