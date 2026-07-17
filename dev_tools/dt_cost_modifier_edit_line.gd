class_name DTCostModifierEditLine
extends Control

signal cost_changed(card_id: int, cost_modifier: int)
signal remove(edit_line: DTCostModifierEditLine)

@export var card_description_label: Label
@export var cost_modifier_spin_box: SpinBox

@export var card_id: int
@export var cost_modifier: int

func construct(p_card_id: int, p_cost_modifier: int) -> DTCostModifierEditLine:
	card_id = p_card_id
	cost_modifier = p_cost_modifier
	var card_data: CardData = Globals.get_card(card_id)
	card_description_label.text = "{0} {1}".format([
		CardData.CardType.keys()[card_data.card_type],
		card_data.modifier
		])
	cost_modifier_spin_box.value = cost_modifier
	return self


func _on_cost_modifier_spin_box_value_changed(value: float) -> void:
	cost_modifier = int(value)
	cost_changed.emit(card_id, cost_modifier)


func _on_remove_button_pressed() -> void:
	remove.emit(self)
