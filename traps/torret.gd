extends Node2D

var direction = Vector2(-1,0)
var bullet_preload  = preload("res://traps/torret_bullet.tscn")
var shoot = true
var hp = 3
@onready var spawn = $Marker2D
@onready var timer = $Timer


func shoot_bullet():
	var bullet = bullet_preload.instantiate()
	bullet.direction = direction
	bullet.position = spawn.global_position
	var bullet_animation = bullet.get_node("AnimationPlayer")
	bullet_animation.play("shoot")
	get_parent().add_child(bullet)
	


func _on_timer_timeout() -> void:
	shoot_bullet()

func take_damage():
	hp -= 1
	print("dano")
	if hp <= 0:
		queue_free()
func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("weapons"):
		self.take_damage()
