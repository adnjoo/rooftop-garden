extends Node2D

@export var ground_tilemap: TileMap
@export var plant_scene: PackedScene
@onready var plants_root: Node2D = $Plants

var planted: Dictionary = {} # Vector2i -> Node

func _ready() -> void:
	var day_manager = get_node("/root/Main/UI/DayManager")
	day_manager.day_advanced.connect(_on_day_advanced)

func _on_day_advanced(_day: int) -> void:
	for plant in planted.values():
		if plant.has_method("grow"):
			plant.grow()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		try_plant_at_global_pos(get_global_mouse_position())

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
