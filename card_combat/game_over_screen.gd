class_name GameOverScreen
extends Control

signal submit_nickname(nickname: String)

@export var draggable_card_scene: PackedScene

@export var game_over_label: Label
@export var drops_display: Control
@export var drops_container: Control
@export var drop_capture_selector: Control
@export var nickname_editor: Control
@export var caught_monster_label: Label
@export var nickname_line_edit: LineEdit

func victory():
	_hide_all()
	game_over_label.show()
	game_over_label.text = "VICTORY"
	drop_capture_selector.show()
	show()

func defeat():
	_hide_all()
	game_over_label.show()
	game_over_label.text = "DEFEAT"
	show()

func run():
	_hide_all()
	game_over_label.show()
	game_over_label.text = "ESCAPED"
	show()

func display_drops(drops: Array):
	_hide_all()
	game_over_label.show()
	drops_display.show()
	for child in drops_container.get_children():
		child.queue_free()
	for drop_id in drops:
		var card_drop: DraggableCard = draggable_card_scene.instantiate()
		card_drop = card_drop.construct(Globals.get_card(drop_id), true, false)
		drops_container.add_child(card_drop)

func display_capture(wild_monster: WildMonsterData):
	_hide_all()
	nickname_editor.show()
	caught_monster_label.text = "You caugh a {0}! Give them a name?".format([wild_monster.name])
	nickname_line_edit.placeholder_text = wild_monster.name

func _hide_all():
	game_over_label.hide()
	drops_display.hide()
	nickname_editor.hide()
	drop_capture_selector.hide()


func _on_nickname_line_edit_text_submitted(new_text: String) -> void:
	var nickname: String = new_text if new_text != "" else nickname_line_edit.placeholder_text
	submit_nickname.emit(nickname)


func _on_nickname_confirm_button_pressed() -> void:
	var nickname: String = nickname_line_edit.text if nickname_line_edit.text != "" else nickname_line_edit.placeholder_text
	submit_nickname.emit(nickname)
