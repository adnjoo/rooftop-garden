extends Node

enum Tool { SEED, WATER }

signal carrots_changed(total: int)
signal day_changed(day: int)
signal seeds_changed(total: int)
signal tool_changed(tool: Tool)

var current_day: int = 1
var harvested_carrots: int = 0
var seed_count: int = 3
var current_tool: Tool = Tool.SEED

func add_carrot() -> void:
	harvested_carrots += 1
	carrots_changed.emit(harvested_carrots)

func advance_day() -> void:
	current_day += 1
	day_changed.emit(current_day)

func add_seeds(amount: int) -> void:
	seed_count += amount
	seeds_changed.emit(seed_count)

func remove_seed() -> bool:
	if seed_count > 0:
		seed_count -= 1
		seeds_changed.emit(seed_count)
		return true
	return false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tool_seed"):
		current_tool = Tool.SEED
		tool_changed.emit(current_tool)
	if Input.is_action_just_pressed("tool_water"):
		current_tool = Tool.WATER
		tool_changed.emit(current_tool)
