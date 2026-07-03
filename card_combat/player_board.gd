class_name PlayerBoard
extends CardGameBoard

@export var end_turn_button: Button

func start_game(p_deck: PlayableDeck, start_hand_size: int):
	super.start_game(p_deck, start_hand_size)
	end_turn_button.disabled = false

func end_game():
	super.end_game()
	end_turn_button.disabled = true

func start_turn():
	super.start_turn()
	end_turn_button.disabled = false

func end_turn():
	super.end_turn()
	end_turn_button.disabled = true

func _on_end_turn_button_pressed() -> void:
	end_turn()
