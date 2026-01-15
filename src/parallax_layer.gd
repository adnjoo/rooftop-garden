extends Parallax2D

@export var speed := 4.0 # pixels per second

func _process(delta: float) -> void:
	scroll_offset.x += speed * delta
