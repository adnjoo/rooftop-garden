extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta: float) -> void:
	# Get input direction (WASD + Arrow keys)
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Set velocity
	velocity = direction * SPEED
	
	# Move the player
	move_and_slide()
	
	# Play animation
	if velocity.length() == 0:
		$AnimatedSprite2D.play("idle")
	else:
		$AnimatedSprite2D.stop()
