extends CharacterBody2D

const SPEED = 300.0
const ARRIVAL_THRESHOLD = 10.0

var target_position: Vector2
var is_moving_to_target = false
var last_direction = Vector2.DOWN

func _ready() -> void:
	target_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target_position = get_global_mouse_position()
			is_moving_to_target = true
	elif event is InputEventScreenTouch:
		if event.pressed:
			target_position = get_canvas_transform().affine_inverse() * event.position
			is_moving_to_target = true

func _physics_process(_delta: float) -> void:
	# Check for WASD/arrow key input
	var keyboard_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if keyboard_direction != Vector2.ZERO:
		# Keyboard input takes priority - cancel tap-to-move
		is_moving_to_target = false
		last_direction = keyboard_direction
		velocity = keyboard_direction * SPEED
	elif is_moving_to_target:
		# Tap-to-move
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		if distance < ARRIVAL_THRESHOLD:
			is_moving_to_target = false
			velocity = Vector2.ZERO
		else:
			last_direction = direction
			velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	update_animation()

func update_animation() -> void:
	if velocity.length() == 0:
		# Idle - prioritize sideways for diagonals
		if last_direction.x != 0:
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("idle_up")
		else:
			$AnimatedSprite2D.play("idle_down")
	else:
		# Walking - prioritize sideways for diagonals
		if last_direction.x != 0:
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("walk_up")
		else:
			$AnimatedSprite2D.play("walk_down")
