class_name Plant
extends Sprite2D

@export var stage_textures: Array[Texture2D] = []
@export var growth_days: int = 1
var current_stage: int = 0

func grow() -> void:
	current_stage += 1
	if current_stage < stage_textures.size():
		texture = stage_textures[current_stage]

func is_harvestable() -> bool:
	return current_stage >= stage_textures.size() - 1

func get_harvest_item() -> String:
	return "generic"  # Override in subclasses
