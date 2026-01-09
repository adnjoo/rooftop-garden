extends CharacterBody2D

const SPEED = 300.0
const ARRIVAL_THRESHOLD = 10.0

var target_position: Vector2
var is_moving = false
var last_direction = Vector2.DOWN

func _ready() -> void:
	target_position = global_position

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			target_position = get_global_mouse_position()
			is_moving = true
	elif event is InputEventScreenTouch:
		if event.pressed:
			target_position = get_canvas_transform().affine_inverse() * event.position
			is_moving = true

func _physics_process(_delta: float) -> void:
	if is_moving:
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		if distance < ARRIVAL_THRESHOLD:
			is_moving = false
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
		# Idle - check horizontal first for diagonals
		if abs(last_direction.x) > abs(last_direction.y):
			$AnimatedSprite2D.play("idle_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("idle_up")
		else:
			$AnimatedSprite2D.play("idle_down")
	else:
		# Walking - check horizontal first for diagonals
		if abs(last_direction.x) > abs(last_direction.y):
			$AnimatedSprite2D.play("walk_side")
			$AnimatedSprite2D.flip_h = (last_direction.x < 0)
		elif last_direction.y < 0:
			$AnimatedSprite2D.play("walk_up")
		else:
			$AnimatedSprite2D.play("walk_down")
