
extends Actor

export var stomp_impulse: = 600.0

func _on_StompDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	die()

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	_velocity - move_and_slide(_velocity, FLOOR_NORMAL)

func on_floor():
	if $Floor.is_colliding():
		return true
	return false

func get_direction() -> Vector2:
	return Vector2( Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
	 - Input.get_action_strength("jump") if on_floor() and Input.is_action_just_pressed("ui_up") else 0.0
	) 

func calculate_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	var out: = linear_velocity 
	out.x = speed.x * direction.x
	out.y += gravity *get_physics_process_delta_time()
	if direction.y != 0.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, stomp_impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") else -stomp_impulse
	return Vector2(linear_velocity.x, stomp_jump)

func die() -> void:
	PlayerData.deaths += 1
	queue_free()

