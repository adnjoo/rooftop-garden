extends Control

@export var day_label: Label
@export var next_day_button: Button
@export var carrot_label: Label
@export var seed_label: Label
@export var tool_label: Label

func _ready() -> void:
	next_day_button.pressed.connect(_on_next_day_pressed)
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.carrots_changed.connect(_on_carrots_changed)
	GameManager.seeds_changed.connect(_on_seeds_changed)
	GameManager.tool_changed.connect(_on_tool_changed)
	_update_day_label()
	_update_carrot_label()
	_update_seed_label()
	_update_tool_label()

func _on_next_day_pressed() -> void:
	GameManager.advance_day()

func _on_day_changed(_day: int) -> void:
	_update_day_label()

func _on_carrots_changed(_total: int) -> void:
	_update_carrot_label()

func _update_day_label() -> void:
	day_label.text = "Day " + str(GameManager.current_day)

func _update_carrot_label() -> void:
	carrot_label.text = str(GameManager.harvested_carrots)

func _on_seeds_changed(_total: int) -> void:
	_update_seed_label()

func _update_seed_label() -> void:
	seed_label.text = str(GameManager.seed_count)

func _on_tool_changed(_tool: GameManager.Tool) -> void:
	_update_tool_label()

func _update_tool_label() -> void:
	if GameManager.current_tool == GameManager.Tool.SEED:
		tool_label.text = "Tool: Seeding"
	else:
		tool_label.text = "Tool: Watering"
