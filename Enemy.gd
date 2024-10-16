extends CharacterBody2D


class_name Enemy

# Properties
var speed: float = 75
var health: int = 50
var hurt: bool = false
var direction: Vector2 = Vector2.ZERO
var last_direction: String = "right" 

@onready var target = get_tree().get_first_node_in_group("Player")
@onready var animation = $AnimationPlayer
@onready var animation_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D

func _process(delta: float) -> void:
	
	if hurt:
		if last_direction == "right":
			animation.play("hurt_right")
		elif last_direction == "left":
			animation.play("hurt_left")
		return
	
	var direction = Vector2.ZERO
	if target:
		direction = target.global_position - global_position
		if direction != Vector2.ZERO:
			direction = direction.normalized()
			velocity = speed * direction

			
			if direction.x > 0:
				animation.play("walk_right")
				last_direction = "right"
			elif direction.x < 0:
				animation.play("walk_left")
				last_direction = "left"

			move_and_slide()

	
	


	
func take_damage(damage: int) -> void:
	
	if hurt:
		return
	health -= damage
	if health <= 0:
		sprite.visible = false
		animation_sprite.visible = true
		animation_sprite.play("die")
		target = null
		timer.wait_time = 0.2
		timer.start()
		await timer.timeout
		queue_free()
		return
	
	hurt = true
	
	print("Health: ", health)
	print("Damage: ", damage)

	
	timer.wait_time = 0.5
	if not timer.is_stopped():
		timer.stop()
	timer.start()
	await timer.timeout
	hurt = false 

	
	target = get_tree().get_first_node_in_group("Player")
	if last_direction == "right":
		animation.play("walk_right")
	elif last_direction == "left":
		animation.play("walk_left")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt_left" or anim_name == "hurt_right":
		pass  

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("weapons"):
		
		take_damage(body.damage)
