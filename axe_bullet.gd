extends Node2D

class_name AxeBullet

var speed: float = 70 

var direction: Vector2

func set_direction(dir: Vector2) -> void:
	direction = dir

func _process(delta: float) -> void:
	position += direction * speed * delta  
   


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
