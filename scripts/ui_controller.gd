extends Control

@export var day_label: Label
@export var next_day_button: Button

func _ready() -> void:
	next_day_button.pressed.connect(_on_next_day_pressed)
	DayManager.day_advanced.connect(_on_day_advanced)
	_update_day_label()

func _on_next_day_pressed() -> void:
	DayManager.advance_day()

func _on_day_advanced(_day: int) -> void:
	_update_day_label()

func _update_day_label() -> void:
	day_label.text = "Day " + str(DayManager.current_day)
