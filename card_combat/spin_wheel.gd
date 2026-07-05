class_name SpinWheel
extends Control

@export var value_label: Label
@export var pivot: Control


func set_value(p_value: int):
	value_label.text = str(p_value)

func set_value_animated(p_value: int):
	var tween = get_tree().create_tween()
	tween.tween_property(pivot, "rotation_degrees", 55, 0.3)
	tween.tween_property(value_label, "text", str(p_value), 0)
	tween.tween_property(pivot, "rotation_degrees", 0, 0.3).from(-55)
