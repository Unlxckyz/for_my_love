extends Node2D
@onready var animation = $AnimationPlayer
@onready var direction = Vector2.ZERO
var damage = 1
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_right" or "attack_left" or "attack_up" or "attack_down":
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("rock"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
