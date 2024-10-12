extends Area2D
class_name weaponsEnemy
@onready var animation = $AnimationPlayer
@onready var damage = 10
@onready var direction = Vector2.ZERO
var knockback_force = 300.0


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(damage)
		if knockback_force > 0:
			apply_knockback_force(body,direction)
func apply_knockback_force(target,direction):
	var knockback_direction = direction
	target.position += knockback_direction * knockback_force * get_process_delta_time()
