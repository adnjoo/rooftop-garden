extends Node

enum Tool { SEED, WATER }

signal carrots_changed(total: int)
signal day_changed(day: int)
signal seeds_changed(total: int)
signal tool_changed(tool: Tool)
signal goal_reached()

var current_day: int = 1
var carrots_total: int = 0
var seed_count: int = 3
var current_tool: Tool = Tool.SEED
var has_won: bool = false

func add_carrot() -> void:
	carrots_total += 1
	carrots_changed.emit(carrots_total)
	
	# Check win condition
	if carrots_total >= 10 and not has_won:
		has_won = true
		goal_reached.emit()

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

func restart_run() -> void:
	current_day = 1
	seed_count = 3
	carrots_total = 0
	has_won = false
	
	# Emit all state change signals
	day_changed.emit(current_day)
	seeds_changed.emit(seed_count)
	carrots_changed.emit(carrots_total)
	
	# Clear all plants via signal (PlantManager will listen)
	# We'll use a signal to avoid direct dependency
	get_tree().call_group("plant_manager", "clear_all_plants")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tool_seed"):
		current_tool = Tool.SEED
		tool_changed.emit(current_tool)
	if Input.is_action_just_pressed("tool_water"):
		current_tool = Tool.WATER
		tool_changed.emit(current_tool)
