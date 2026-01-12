extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func _ready() -> void:
	sprite.play("splash")
	sprite.animation_finished.connect(_on_anim_finished)

func _on_anim_finished() -> void:
	queue_free()
