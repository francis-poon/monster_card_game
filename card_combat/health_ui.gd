class_name HealthUI
extends Control

@export var spin_wheel: SpinWheel
@export var max_health_label: Label
@export var health_bar: ClipTextureProgressBar

var health: int = 0:
	set(value):
		if health != value:
			spin_wheel.set_value_animated(value)
		health = value
		health_bar.value = value
var max_health: int = 0:
	set(value):
		max_health = value
		max_health_label.text = str(value)
		health_bar.max_value = value
