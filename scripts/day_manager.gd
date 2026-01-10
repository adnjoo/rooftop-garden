extends Node

signal day_advanced(day: int)

var current_day: int = 1

@onready var day_label: Label = $"../DayLabel"
@onready var next_day_button: Button = $"../NextDayButton"

func _ready() -> void:
	next_day_button.pressed.connect(_on_next_day_pressed)
	day_label.text = "Day " + str(current_day)

func _on_next_day_pressed() -> void:
	advance_day()

func advance_day() -> void:
	current_day += 1
	day_label.text = "Day " + str(current_day)
	day_advanced.emit(current_day)
