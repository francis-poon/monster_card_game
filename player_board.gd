class_name PlayerBoard
extends Control

@export var card_hand: CardHand
@export var card_scene: PackedScene


func _on_draw_card_button_pressed() -> void:
	var new_card: DraggableCard = card_scene.instantiate()
	card_hand.add_card(new_card)
