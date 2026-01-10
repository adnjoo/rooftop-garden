extends Node

signal carrots_changed(total: int)
signal day_changed(day: int)

var current_day: int = 1
var harvested_carrots: int = 0

func add_carrot() -> void:
	harvested_carrots += 1
	carrots_changed.emit(harvested_carrots)

func advance_day() -> void:
	current_day += 1
	day_changed.emit(current_day)
