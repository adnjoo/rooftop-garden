extends Control

signal keep_playing_pressed
signal restart_run_pressed

@export var title_label: Label
@export var message_label: Label
@export var days_label: Label
@export var keep_playing_button: Button
@export var restart_button: Button

func _ready() -> void:
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	add_to_group("win_overlay")
	if keep_playing_button:
		keep_playing_button.pressed.connect(_on_keep_playing_pressed)
	if restart_button:
		restart_button.pressed.connect(_on_restart_run_pressed)

func show_overlay() -> void:
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	_update_days_label()

func hide_overlay() -> void:
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE

func _update_days_label() -> void:
	if days_label:
		days_label.text = "Days taken: " + str(GameManager.current_day)

func _on_keep_playing_pressed() -> void:
	keep_playing_pressed.emit()

func _on_restart_run_pressed() -> void:
	restart_run_pressed.emit()
