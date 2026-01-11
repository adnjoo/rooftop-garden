extends Node

enum Tool { SEED, WATER }

signal day_changed
signal carrots_changed
signal seeds_changed
signal tool_changed()
signal goal_reached()

var current_day: int = 1: set = set_current_day
var carrots: int = 0: set = set_carrots
var seeds: int = 3: set = set_seeds
var current_tool: Tool = Tool.SEED
var has_won: bool = false
var win_number: int = 3

func set_current_day(value: int) -> void:
	current_day = value
	day_changed.emit()

func set_carrots(value2: int) -> void:
	carrots = value2
	carrots_changed.emit()

func set_seeds(amount: int) -> void:
	seeds = amount
	seeds_changed.emit()

func restart_run() -> void:
	self.current_day = 1
	self.seeds = 3
	self.carrots = 0
	has_won = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tool_seed"):
		current_tool = Tool.SEED
		tool_changed.emit(current_tool)
	if Input.is_action_just_pressed("tool_water"):
		current_tool = Tool.WATER
		tool_changed.emit(current_tool)
