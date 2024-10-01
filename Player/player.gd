extends CharacterBody2D

var speed = 100
var hp = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $Elf
var last_direction = Vector2.ZERO
func _ready() -> void:
	animation.play("Respawn")
func _process(delta: float) -> void:
	var direction = Vector2.ZERO 
	if Input.is_action_pressed("up"):
		if last_direction.x > 0:
			animation.play("walk_right")
		if last_direction.x < 0:
			animation.play("walk_left")
			
		direction.y -= 1
	if Input.is_action_pressed("down"):
		if last_direction.x > 0:
			animation.play("walk_right")
		else:
			animation.play("walk_left")
		direction.y += 1
	if Input.is_action_pressed("right"):
		direction.x += 1
		animation.play("walk_right")
		last_direction = Vector2(1,0)
	if Input.is_action_pressed("left"):
		direction.x -= 1
		animation.play("walk_left")
		last_direction = Vector2(-1, 0)  # Direção para a esquerda

		
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = speed * direction
		move_and_slide()
	else:
		if last_direction.x > 0: 
			animation.play("idle_right")
			
		if last_direction.x < 0: 
			animation.play("idle_left") 
			


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Respawn":
		last_direction = Vector2(-1, 0)
		
