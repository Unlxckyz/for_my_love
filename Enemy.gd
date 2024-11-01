extends CharacterBody2D

class_name Enemy

# Properties
var speed: float = 75
var health: int = 50
var hurt: bool = false
var detection_radius: float = 100.0  # Raio de detecção do jogador
var patrol_radius: float = 450.0  # Raio limite para patrulha
var patrol_timer_duration: float = 2.0  # Intervalo para mudar a direção
var last_direction: String = "right"
var original_position: Vector2

@onready var target = get_tree().get_first_node_in_group("Player")
@onready var animation = $AnimationPlayer
@onready var animation_sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var patrol_timer = $PatrolTimer  
@onready var sprite = $Sprite2D

# Preloads 
var preload_spell_effect = preload("res://spell_effect.tscn")
var preload_die = preload("res://die_effect.tscn")
var preload_slash_effect = preload("res://slash_effect.tscn")

# Patrulha
var random_direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	original_position = global_position
	patrol_timer.wait_time = patrol_timer_duration
	patrol_timer.start()

func _process(delta: float) -> void:
	if hurt:
		animation.play("hurt_" + last_direction)
		return

	if target and is_player_nearby():
		move_towards_player()
	else:
		patrol()

func move_towards_player() -> void:
	var direction = (target.global_position - global_position).normalized()
	velocity = speed * direction

	# Escolhe a animação e a direção
	if direction.x > 0:
		animation.play("walk_right")
		last_direction = "right"
	elif direction.x < 0:
		animation.play("walk_left")
		last_direction = "left"

	move_and_slide()

func patrol() -> void:
	# Se o inimigo está longe demais da posição original, move ele de volta
	if global_position.distance_to(original_position) > patrol_radius:
		random_direction = (original_position - global_position).normalized()
	else:
		# Patrulha aleatória// chat
		if patrol_timer.is_stopped():
			random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			patrol_timer.start()

	velocity = speed * random_direction

	# Define a animação com base na direção
	if random_direction.x > 0:
		animation.play("walk_right")
		last_direction = "right"
	elif random_direction.x < 0:
		animation.play("walk_left")
		last_direction = "left"

	move_and_slide()

func is_player_nearby() -> bool:
	# Verifica se o player está dentro do raio de detecção
	return global_position.distance_to(target.global_position) <= detection_radius

func take_damage(damage: int) -> void:
	if hurt:
		return
	
	health -= damage
	if health <= 0:
		die()
		return
	
	hurt = true
	print("Health: ", health)
	print("Damage: ", damage)

	# Timer para o estado de hurt
	timer.wait_time = 0.5
	timer.start()
	await timer.timeout
	hurt = false
	
	animation.play("walk_" + last_direction)

func die() -> void:
	sprite.visible = false
	target = null
	Global.rat_killed += 1
	var die_effect = preload_die.instantiate()
	die_effect.position = global_position
	get_tree().root.add_child(die_effect)  # Garante que o efeito é adicionado à cena principal // alguns erros que get_parent().add_child() e chat corrigiu
	queue_free()

func _slash_effect():
	var slash_effect = preload_slash_effect.instantiate()
	slash_effect.position = global_position
	get_tree().root.add_child(slash_effect)  # Garante que o efeito é adicionado à cena principal

func _spell_effect():
	var spell_effect = preload_spell_effect.instantiate()
	spell_effect.position = global_position
	get_tree().root.add_child(spell_effect)  # Garante que o efeito é adicionado à cena principal
