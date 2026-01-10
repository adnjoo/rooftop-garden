extends Node

signal day_advanced(day: int)

var current_day: int = 1

func advance_day() -> void:
	current_day += 1
	day_advanced.emit(current_day)
