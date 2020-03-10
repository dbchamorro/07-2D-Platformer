extends "res://Actors/Actor.gd"

onready var stomp_area: Area2D = $StompArea2D

export var score: = 100

func _ready() -> void:
	set_physics_process(false)
	_velocity.x = -speed.x

func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
	else:
		die()

func _on_StompDetector_body_entered(body:PhysicsBody2D) -> void:
	if body.global_position.y > get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _physics_process(delta: float) -> void:
	if is_on_wall():
		_velocity.x *= -1.0
	else:
		1
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func die() -> void:
	#PlayerData.score += score
	queue_free()
