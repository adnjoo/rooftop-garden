extends Control

@onready var day_label: Label = $DayLabel
@onready var next_day_button: Button = $NextDayButton
@onready var carrot_label: Label = $CarrotCounter/CarrotLabel
@onready var seed_label: Label = $SeedCounter/SeedLabel
@onready var tool_label: Label = $ToolLabel
@onready var goal_label: Label = $GoalLabel
@onready var win_overlay: Control = $Overlays/WinOverlay

func _ready() -> void:
	next_day_button.pressed.connect(_on_next_day_pressed)
	GameManager.day_changed.connect(_on_day_changed)
	GameManager.carrots_changed.connect(_on_carrots_changed)
	GameManager.seeds_changed.connect(_on_seeds_changed)
	GameManager.tool_changed.connect(_on_tool_changed)
	GameManager.goal_reached.connect(_on_goal_reached)
	_update_day_label()
	_update_carrot_label()
	_update_seed_label()
	_update_tool_label()
	_update_goal_label()
	
	# Connect win overlay signals
	if win_overlay and win_overlay.has_signal("keep_playing_pressed"):
		win_overlay.keep_playing_pressed.connect(_on_keep_playing_pressed)
	if win_overlay and win_overlay.has_signal("restart_run_pressed"):
		win_overlay.restart_run_pressed.connect(_on_restart_run_pressed)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next_day"):
		GameManager.advance_day()

func _on_next_day_pressed() -> void:
	GameManager.advance_day()

func _on_day_changed(_day: int) -> void:
	_update_day_label()

func _on_carrots_changed(_total: int) -> void:
	_update_carrot_label()
	_update_goal_label()

func _update_day_label() -> void:
	day_label.text = "Day " + str(GameManager.current_day)

func _update_carrot_label() -> void:
	carrot_label.text = str(GameManager.carrots_total)

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

func _update_goal_label() -> void:
	if goal_label:
		goal_label.text = "Goal: " + str(GameManager.carrots_total) + " / " + str(GameManager.win_number) + " carrots"

func _on_goal_reached() -> void:
	print("Goal reached")
	if win_overlay and win_overlay.has_method("show_overlay"):
		print("Showing win overlay")
		win_overlay.show_overlay()

func _on_keep_playing_pressed() -> void:
	if win_overlay and win_overlay.has_method("hide_overlay"):
		win_overlay.hide_overlay()

func _on_restart_run_pressed() -> void:
	GameManager.restart_run()
	if win_overlay and win_overlay.has_method("hide_overlay"):
		win_overlay.hide_overlay()
