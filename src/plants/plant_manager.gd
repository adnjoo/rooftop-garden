extends Node2D

# Constants to remove magic numbers
const TILE_SOURCE_DRY = 1
const TILE_SOURCE_WET = 2

@export var ground_tilemap: TileMap
@export var plant_scene: PackedScene
@export var water_splash_scene: PackedScene

@onready var plants_root: Node2D = $Plants

var planted: Dictionary = {}  # Vector2i -> Plant Node
var watered_cells: Array[Vector2i] = [] # Track wet cells for easy reset

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)
	add_to_group("plant_manager")

func _on_day_changed() -> void:
	# Grow plants
	for plant in planted.values():
		if plant.has_method("grow"):
			plant.grow()
	
	# Reset only the cells we actually watered
	for cell in watered_cells:
		ground_tilemap.set_cell(0, cell, TILE_SOURCE_DRY, Vector2i.ZERO)
	watered_cells.clear()

func _unhandled_input(event: InputEvent) -> void:
	var pos := Vector2.ZERO
	var pressed := false
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pos = get_global_mouse_position()
		pressed = true
	elif event is InputEventScreenTouch and event.pressed:
		pos = get_canvas_transform().affine_inverse() * event.position
		pressed = true
	
	if not pressed: return
	
	# Helper logic for input flow
	var cell = _get_cell_from_global(pos)
	if not try_harvest(cell):
		match GameManager.current_tool:
			GameManager.Tool.SEED:  try_plant(cell)
			GameManager.Tool.WATER: try_water(cell)

# --- Helper Methods ---

func _get_cell_from_global(global_pos: Vector2) -> Vector2i:
	var local_pos = ground_tilemap.to_local(global_pos)
	return ground_tilemap.local_to_map(local_pos)

func _get_cell_center_global(cell: Vector2i) -> Vector2:
	var local_center = ground_tilemap.map_to_local(cell)
	return ground_tilemap.to_global(local_center)

# --- Action Logic ---

func try_harvest(cell: Vector2i) -> bool:
	var plant = planted.get(cell)
	if not plant or not plant.is_harvestable():
		return false
	
	plant.queue_free()
	planted.erase(cell)
	
	GameManager.set_carrots(GameManager.carrots + 1)
	GameManager.set_seeds(GameManager.seeds + 2)
	return true

func try_plant(cell: Vector2i) -> void:
	if planted.has(cell) or GameManager.seeds <= 0: return
	
	var tile_data = ground_tilemap.get_cell_tile_data(0, cell)
	if not tile_data or not tile_data.get_custom_data("plantable"): return

	# Spend seed
	GameManager.set_seeds(GameManager.seeds - 1)

	# Instance plant
	var plant = plant_scene.instantiate()
	plants_root.add_child(plant)
	plant.global_position = _get_cell_center_global(cell)
	planted[cell] = plant

	# Check if planting in pre-watered soil
	if ground_tilemap.get_cell_source_id(0, cell) == TILE_SOURCE_WET:
		_apply_water_to_plant(plant)

func try_water(cell: Vector2i) -> void:
	var tile_data = ground_tilemap.get_cell_tile_data(0, cell)
	if not tile_data or not tile_data.get_custom_data("plantable"): return

	# Update Tile to wet
	if ground_tilemap.get_cell_source_id(0, cell) != TILE_SOURCE_WET:
		ground_tilemap.set_cell(0, cell, TILE_SOURCE_WET, Vector2i.ZERO)
		watered_cells.append(cell)
		_spawn_water_splash(cell)
	
	# Update Plant
	if planted.has(cell):
		_apply_water_to_plant(planted[cell])

func _apply_water_to_plant(plant: Node) -> void:
	if plant is Plant and not plant.watered:
		plant.watered = true
		plant.update_visual_feedback()

func _spawn_water_splash(cell: Vector2i) -> void:
	var splash = water_splash_scene.instantiate() as Node2D
	plants_root.add_child(splash)
	splash.global_position = _get_cell_center_global(cell)
