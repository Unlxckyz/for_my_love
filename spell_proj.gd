extends Node2D

var speed = 150
var direction = Vector2.ZERO
var damage = 20

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta
