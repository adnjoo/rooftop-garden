extends Control

@export var title_label: Label
@onready var message_label: Label = $Background/Panel/VBoxContainer/MessageLabel
@onready var days_label: Label = $Background/Panel/VBoxContainer/DaysLabel
@export var keep_playing_button: Button
@export var restart_button: Button

func _ready() -> void:
	print("WinOverlay ready")
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	add_to_group("win_overlay")

func show_overlay() -> void:
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	_update_message_label()
	_update_days_label()

func hide_overlay() -> void:
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE

func _update_days_label() -> void:
	days_label.text = "Days taken: " + str(GameManager.current_day - GameManager.INITIAL_DAY)

func _update_message_label() -> void:
	message_label.text = "You shipped " + str(GameManager.carrots) + " carrots. Thanks for playing the demo!"

func _on_restart_button_pressed() -> void:
	restart()

func restart() -> void:
	GameManager.restart_run()
	hide_overlay()

func _on_keep_playing_button_pressed() -> void:
	hide_overlay()
