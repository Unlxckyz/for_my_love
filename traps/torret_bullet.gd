extends Node2D

var speed = 200
var knockback_force
var direction = Vector2.ZERO
var damage = 10

func _init() -> void:
	direction = Vector2.ZERO
	damage = 10
	knockback_force = 400.0
func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("colision_wall"):
		queue_free()
	if body is CharacterBody2D:
		if body.is_in_group("Player"):
			apply_knockback_force(body)
			body.take_damage(damage)
	
func apply_knockback_force(target):
	var knockback_direction = Vector2(-1,0)
	target.position += knockback_direction * knockback_force * get_process_delta_time()

func disable_trap():
	$CollisionShape2D.disabled = true  
	$AnimationPlayer.stop()  
