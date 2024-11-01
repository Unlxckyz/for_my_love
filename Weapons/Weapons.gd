extends Area2D
class_name weapons
@onready var animation = $AnimationPlayer
@onready var damage = 10
@onready var direction = Vector2.ZERO
var knockback_force = 300.0



func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(damage)
		body._slash_effect()
		if knockback_force > 0 and not body.is_in_group("Elite"):
			apply_knockback_force(body)
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_right" or "attack_left" or "attack_up" or "attack_down":
		queue_free()
func apply_knockback_force(target):
	var knockback_direction = (target.global_position - global_position).normalized()
	target.position += knockback_direction * knockback_force * get_process_delta_time()
