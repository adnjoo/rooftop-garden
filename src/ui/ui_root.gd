extends Control

@onready var carrot_label: Label = $VBoxContainer/CarrotCounter/CarrotLabel
@onready var seed_label: Label = $VBoxContainer/SeedCounter/SeedLabel
@onready var tool_label: Label = $VBoxContainer/ToolLabel
@onready var goal_label: Label = $VBoxContainer/GoalLabel
@onready var win_overlay: Control = $Overlays/WinOverlay
@onready var day_label: Label = $VBoxContainer/DayLabel

func _ready() -> void:
	GameManager.carrots_changed.connect(_update_carrot_label)
	GameManager.seeds_changed.connect(_update_seed_label)
	GameManager.tool_changed.connect(_on_tool_changed)
	GameManager.goal_reached.connect(_on_goal_reached)
	GameManager.day_changed.connect(_update_day_label)

	_update_carrot_label()
	_update_seed_label()
	_update_tool_label()
	_update_day_label()
	
	# Connect win overlay signals
	if win_overlay and win_overlay.has_signal("keep_playing_pressed"):
		win_overlay.keep_playing_pressed.connect(_on_keep_playing_pressed)
	if win_overlay and win_overlay.has_signal("restart_run_pressed"):
		win_overlay.restart_run_pressed.connect(_on_restart_run_pressed)

func _update_carrot_label() -> void:
	carrot_label.text = str(GameManager.carrots)
	goal_label.text = "Goal: " + str(GameManager.carrots) + " / " + str(GameManager.win_number) + " carrots"

func _update_seed_label() -> void:
	seed_label.text = str(GameManager.seeds)

func _on_tool_changed(_tool: GameManager.Tool) -> void:
	_update_tool_label()

func _update_tool_label() -> void:
	if GameManager.current_tool == GameManager.Tool.SEED:
		tool_label.text = "Tool: Seeding"
	else:
		tool_label.text = "Tool: Watering"		

func _on_goal_reached() -> void:
	win_overlay.show_overlay()

func _on_keep_playing_pressed() -> void:
	win_overlay.hide_overlay()

func _on_restart_run_pressed() -> void:
	GameManager.restart_run()
	win_overlay.hide_overlay()

func _update_day_label() -> void:
	day_label.text = "Day: " + str(GameManager.current_day)
