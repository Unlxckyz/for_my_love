extends Node2D

var speed = 200
var knockback_force = 400.0
var direction = Vector2.ZERO
var damage = 10

func set_direction(dir: Vector2) -> void:
	direction = dir

func _init() -> void:
	direction = Vector2.ZERO

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("wall") and body is TileMapLayer:
		queue_free()
	elif body.is_in_group("Player") and body is CharacterBody2D:
		apply_knockback_force(body)
		if body.has_method("take_damage"):
			body.take_damage(damage)
		queue_free()  # Remove a bala após causar dano

func apply_knockback_force(target: CharacterBody2D) -> void:
	var knockback_direction = (target.global_position - global_position).normalized()
	target.position += knockback_direction * knockback_force * get_process_delta_time()

func disable_trap():
	$CollisionShape2D.disabled = true  
	$AnimationPlayer.stop()
