extends Node

enum Tool { SEED, WATER }

signal day_changed
signal carrots_changed
signal seeds_changed
signal tool_changed()
signal goal_reached()

var INITIAL_SEEDS: int = 3
var INITIAL_CARROTS: int = 0
var INITIAL_DAY: int = 1

var current_day: int = INITIAL_DAY: set = set_current_day
var carrots: int = INITIAL_CARROTS: set = set_carrots
var seeds: int = INITIAL_SEEDS: set = set_seeds
var current_tool: Tool = Tool.SEED
var has_won: bool = false
var win_number: int = 3

func set_current_day(value: int) -> void:
	current_day = value
	day_changed.emit()

func set_carrots(value: int) -> void:
	carrots = value
	carrots_changed.emit()

func set_seeds(amount: int) -> void:
	seeds = amount
	seeds_changed.emit()

func restart_run() -> void:
	self.current_day = INITIAL_DAY
	self.seeds = INITIAL_SEEDS
	self.carrots = INITIAL_CARROTS
	has_won = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("tool_seed"):
		current_tool = Tool.SEED
		tool_changed.emit(current_tool)
	if Input.is_action_just_pressed("tool_water"):
		current_tool = Tool.WATER
		tool_changed.emit(current_tool)
