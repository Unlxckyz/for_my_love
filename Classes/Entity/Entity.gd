extends CharacterBody2D
class_name Entity

@export var speed : float
@export var hp : int
@export var xp : int
@export var hurt : bool
@export var damage : int
@export var animation = AnimationPlayer
@export var animation_sprite = AnimatedSprite2D
@export var sprite = Sprite2D
@export var timer = Timer
func take_damage(_damage):
	hp-= _damage
	hurt = true
	if hp <= 0:
		queue_free()
	
