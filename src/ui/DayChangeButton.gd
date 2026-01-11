extends Control

@onready var day_label: Label = $DayLabel
@onready var next_day_button: Button = $NextDayButton

func _ready() -> void:
	next_day_button.pressed.connect(_on_next_day_pressed)
	GameManager.day_changed.connect(_on_day_changed)
	_update_day_label()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_day"):
		GameManager.advance_day()

func _on_next_day_pressed() -> void:
	GameManager.advance_day()

func _on_day_changed(_day: int) -> void:
	_update_day_label()

func _update_day_label() -> void:
	day_label.text = "Day " + str(GameManager.current_day)
