class_name Plant
extends Sprite2D

@export var stage_textures: Array[Texture2D] = []
@export var growth_days: int = 1
var current_stage: int = 0
var watered := false

func grow() -> void:
	if watered:
		current_stage += 1
		if current_stage < stage_textures.size():
			texture = stage_textures[current_stage]
	watered = false
	update_visual_feedback()

func update_visual_feedback() -> void:
	if watered:
		modulate = Color(0.8, 0.9, 1.0)  # Slight blue tint when watered
	else:
		modulate = Color.WHITE

func play_water_fx() -> void:
	# Placeholder for future water effects (particles, sound, etc.)
	pass

func is_harvestable() -> bool:
	return current_stage >= stage_textures.size() - 1

func get_harvest_item() -> String:
	return "generic"  # Override in subclasses
