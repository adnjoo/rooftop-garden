extends Sprite2D

@export var stage_textures: Array[Texture2D] = []
var current_stage: int = 0

func grow() -> void:
	current_stage += 1
	if current_stage < stage_textures.size():
		texture = stage_textures[current_stage]
