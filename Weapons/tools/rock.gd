extends CharacterBody2D
var smoke_preload = preload("res://Weapons/tools/smoke.tscn")
var hp = 2
@onready var animation = $AnimationPlayer
func take_damage(damage):
	hp-= damage
	if hp == 1:
		animation.play("one_shot")
	if hp <= 0:
		var smoke = smoke_preload.instantiate()
		smoke.position = global_position
		get_parent().add_child(smoke)
		queue_free()
