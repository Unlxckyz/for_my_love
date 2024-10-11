extends Node2D

var speed = 200
var direction = Vector2.ZERO
var damage = 10
@onready var particle = preload("res://traps/particle_torret.tscn")

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is TileMap:
		queue_free()
	
