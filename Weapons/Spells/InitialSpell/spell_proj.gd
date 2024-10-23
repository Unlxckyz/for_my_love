extends Node2D

var speed = 150
var direction = Vector2.ZERO
var damage = 20

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		if body.has_method("take_damage"):
			body._spell_effect()
			body.take_damage(damage)
