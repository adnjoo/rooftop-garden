extends Node2D

signal carrot_harvested(total: int)

@export var ground_tilemap: TileMap
@export var plant_scene: PackedScene
@onready var plants_root: Node2D = $Plants
@onready var carrot_label: Label = get_node("/root/Main/UI/CarrotLabel")

var planted: Dictionary = {} # Vector2i -> Node
var harvested_carrots: int = 0

func _ready() -> void:
	var day_manager = get_node("/root/Main/UI/DayManager")
	day_manager.day_advanced.connect(_on_day_advanced)
	carrot_harvested.connect(_on_carrot_harvested)

func _on_carrot_harvested(total: int) -> void:
	if carrot_label:
		carrot_label.text = "Carrots: " + str(total)

func _on_day_advanced(_day: int) -> void:
	for plant in planted.values():
		if plant.has_method("grow"):
			plant.grow()

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
		# Try harvest first, then plant if nothing to harvest
		if not try_harvest_at_global_pos(pos):
			try_plant_at_global_pos(pos)

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
		harvested_carrots += 1
		carrot_harvested.emit(harvested_carrots)
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

	var plant := plant_scene.instantiate()
	plants_root.add_child(plant)

	var cell_local_center: Vector2 = ground_tilemap.map_to_local(cell)
	plant.global_position = ground_tilemap.to_global(cell_local_center)

	planted[cell] = plant
