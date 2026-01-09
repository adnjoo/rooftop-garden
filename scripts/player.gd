extends CharacterBody2D

const SPEED = 300.0

var last_direction = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction != Vector2.ZERO:
		last_direction = direction
	
	velocity = direction * SPEED
	move_and_slide()
	update_animation()

func update_animation() -> void:
	if velocity.length() == 0:
		# Idle - check horizontal first for diagonals
		if last_direction.x != 0:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("idle_up")
		else:
			$AnimatedSprite2D.play("idle_down")
	else:
		# Walking - check horizontal first for diagonals
		if last_direction.x != 0:
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("walk_up")
		else:
			$AnimatedSprite2D.play("walk_down")
