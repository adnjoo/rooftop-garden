extends Node2D

@export var ground_tilemap: TileMap
@export var plant_scene: PackedScene
@onready var plants_root: Node2D = $Plants

var planted: Dictionary = {} # Vector2i -> Node

func _ready() -> void:
	GameManager.day_changed.connect(_on_day_changed)
	add_to_group("plant_manager")

func _on_day_changed(_day: int) -> void:
	for plant in planted.values():
		if plant.has_method("grow"):
			plant.grow()
	
	# Reset all wet ground tiles back to dry
	if ground_tilemap != null:
		for cell in planted.keys():
			var source_id := ground_tilemap.get_cell_source_id(0, cell)
			if source_id == 2:  # If it's wet ground (source 2)
				ground_tilemap.set_cell(0, cell, 1, Vector2i(0, 0))  # Change back to dry (source 1)

func _unhandled_input(event: InputEvent) -> void:
	var pos: Vector2
	var should_handle := false
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pos = get_global_mouse_position()
		should_handle = true
	elif event is InputEventScreenTouch and event.pressed:
		pos = get_canvas_transform().affine_inverse() * event.position
		should_handle = true
	
	if should_handle:
		# Try harvest first, then check tool mode
		if not try_harvest_at_global_pos(pos):
			if GameManager.current_tool == GameManager.Tool.SEED:
				try_plant_at_global_pos(pos)
			elif GameManager.current_tool == GameManager.Tool.WATER:
				try_water_at_global_pos(pos)

func try_harvest_at_global_pos(global_pos: Vector2) -> bool:
	if ground_tilemap == null:
		return false
	
	var local_pos := ground_tilemap.to_local(global_pos)
	var cell: Vector2i = ground_tilemap.local_to_map(local_pos)
	
	if not planted.has(cell):
		return false
	
	var plant = planted[cell]
	if plant.has_method("is_harvestable") and plant.is_harvestable():
		plant.queue_free()
		planted.erase(cell)
		GameManager.add_carrot()
		GameManager.add_seeds(2)
		return true
	
	return false

func try_plant_at_global_pos(global_pos: Vector2) -> void:
	if ground_tilemap == null or plant_scene == null:
		return

	var local_pos := ground_tilemap.to_local(global_pos)
	var cell: Vector2i = ground_tilemap.local_to_map(local_pos)

	if planted.has(cell):
		return

	var tile_data := ground_tilemap.get_cell_tile_data(0, cell)
	if tile_data == null:
		return

	var is_plantable := bool(tile_data.get_custom_data("plantable"))
	if not is_plantable:
		return

	if not GameManager.remove_seed():
		return

	var plant := plant_scene.instantiate()
	plants_root.add_child(plant)

	var cell_local_center: Vector2 = ground_tilemap.map_to_local(cell)
	plant.global_position = ground_tilemap.to_global(cell_local_center)

	# Check if ground is wet, and if so, set plant as watered
	var source_id := ground_tilemap.get_cell_source_id(0, cell)
	if source_id == 2:  # Wet ground (source 2)
		if plant is Plant:
			plant.watered = true
			plant.update_visual_feedback()

	planted[cell] = plant

func try_water_at_global_pos(global_pos: Vector2) -> void:
	if ground_tilemap == null:
		return
	
	var local_pos := ground_tilemap.to_local(global_pos)
	var cell: Vector2i = ground_tilemap.local_to_map(local_pos)
	
	var tile_data := ground_tilemap.get_cell_tile_data(0, cell)
	if tile_data == null:
		return
	
	var is_plantable := bool(tile_data.get_custom_data("plantable"))
	if not is_plantable:
		return
	
	# Check if it's the dry ground tile (source 1)
	var source_id := ground_tilemap.get_cell_source_id(0, cell)
	if source_id == 1:
		# Change to wet ground tile (source 2)
		ground_tilemap.set_cell(0, cell, 2, Vector2i(0, 0))
	
	# If there's a plant, water it too
	if planted.has(cell):
		var plant = planted[cell]
		if plant is Plant and not plant.watered:
			plant.watered = true
			plant.update_visual_feedback()
			plant.play_water_fx()

func clear_all_plants() -> void:
	# Remove all plants
	for plant in planted.values():
		if is_instance_valid(plant):
			plant.queue_free()
	planted.clear()
	
	# Reset all wet ground tiles back to dry
	if ground_tilemap != null:
		var used_cells := ground_tilemap.get_used_cells(0)
		for cell in used_cells:
			var source_id := ground_tilemap.get_cell_source_id(0, cell)
			if source_id == 2:  # If it's wet ground (source 2)
				ground_tilemap.set_cell(0, cell, 1, Vector2i(0, 0))  # Change back to dry (source 1)
