extends CharacterBody2D

class_name Machine

# Properties
var speed: float = 100
var health: int = 1000
var hurt: bool = false
var detection_radius: bool = false
var patrol_radius: float = 450.0
var patrol_timer_duration: float = 2.0

# Estados da máquina
enum State { PATROL, ATTACK, CHASING }
var current_state: State = State.PATROL

@onready var target = null
@onready var animation = $AnimationPlayer
@onready var sprite = $ratFolk
@onready var timer = $Timer
@onready var patrol_timer = $patrolTimer
@onready var colision_arma = $area_detection/CollisionShape2D
@onready var axe_bullet = preload("res://axe_bullet.tscn")
@onready var attack_timer = $AttackTimer
@onready var health_bar = $CanvasLayer/HealthBar
@onready var name_label = $CanvasLayer/Label
@onready var label_defeated  = $CanvasLayer/BossLabel
@onready var animation_defeated = $CanvasLayer/AnimationPlayer

# Preload 
var preload_spell_effect = preload("res://spell_effect.tscn")
var preload_die = preload("res://die_effect.tscn")
var preload_slash_effect = preload("res://slash_effect.tscn")
@onready var final = $Final
var direction_patrol = Vector2.RIGHT
var chase_distance: float = 500.0 

# Patrulha
var random_direction: Vector2 = Vector2.ZERO
var original_position: Vector2
var is_attacking = false
var is_chasing = false
var is_patrolling = true
var live = true

# Variáveis para ataques
var melee_attack_count = 0  # Contador de ataques corpo a corpo
var max_melee_attacks = 2    # Número máximo de ataques corpo a corpo antes de um ataque à distância

func _ready() -> void:
	original_position = global_position
	patrol_timer.wait_time = patrol_timer_duration
	patrol_timer.start()
	health_bar.init_health(health)
	health_bar.max_value = health

func ranged_attack() -> void:
	var directions = [
		Vector2.RIGHT,
		Vector2.LEFT,
		Vector2.UP,
		Vector2.DOWN,
		Vector2(1, 1).normalized(),
		Vector2(1, -1).normalized(),
		Vector2(-1, 1).normalized(),
		Vector2(-1, -1).normalized()
	]
	
	for direction in directions:
		shoot_axe(direction)

	attack_timer.start()  # Reinicia o timer após o ataque

func shoot_axe(direction: Vector2) -> void:
	var axe_instance = axe_bullet.instantiate()  # Instancia o machado
	axe_instance.global_position = global_position  # Define a posição inicial como a do inimigo
	axe_instance.set_direction(direction)  # Chama uma função no machado para definir a direção
	get_parent().add_child(axe_instance)  # Adiciona o machado à cena

func _process(delta: float) -> void:
	if hurt:
		animation.play("hurt")
		return

	match current_state:
		State.PATROL:
			target = null
			if is_patrolling and not detection_radius:
				patrol()
		State.CHASING:
			if is_chasing and health > 0:
				if health_bar.is_inside_tree():
					health_bar.visible = true
				if name_label.is_inside_tree():
					name_label.visible = true
				
				if target and global_position.distance_to(target.global_position) <= chase_distance:
					move_towards_player()
		State.ATTACK:
			if is_attacking:
				attack()

func move_towards_player() -> void:
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity = speed * direction
		sprite.flip_h = direction.x < 0
		animation.play("walk_right") 
		move_and_slide()

func patrol() -> void:
	if global_position.distance_to(original_position) > patrol_radius:
		random_direction = (original_position - global_position).normalized()
	else:
		random_direction = direction_patrol
		if patrol_timer.is_stopped():
			random_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			patrol_timer.start()

	velocity = speed * random_direction
	sprite.flip_h = random_direction.x < 0
	animation.play("walk_right")  
	move_and_slide()

func attack() -> void:
	if target:
		if melee_attack_count < max_melee_attacks:
			# Executa o ataque corpo a corpo
			if target.global_position.x > global_position.x:
				animation.play("attack_right")
			else:
				animation.play("attack_left") 
			
			melee_attack_count += 1  # Incrementa o contador de ataques corpo a corpo
		else:
			animation.play("detect")
			ranged_attack()
			melee_attack_count = 0  # Reseta o contador de ataques corpo a corpo
func take_damage(damage):
	if not target and health > 0:
		target = get_tree().get_first_node_in_group("Player")
		is_chasing = true
		is_patrolling = false
		is_attacking = false
		current_state = State.CHASING
	health -= damage
	speed += 5
	if health <= 0:
		live = false
		die()
	health_bar.health = health
	
#areas
func _on_area_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing = true
		is_patrolling = false
		target = get_tree().get_first_node_in_group("Player")
		current_state = State.CHASING

func _on_area_detection_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_chasing = false
		is_patrolling = true
		if live:
			if target.global_position.x > global_position.x:
				direction_patrol = Vector2.RIGHT
			else:
				direction_patrol = Vector2.LEFT
		current_state = State.PATROL
		detection_radius = false  

func _on_area_de_dano_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_attacking = true
		detection_radius = true
		is_chasing = false
		attack()  

func _on_area_de_dano_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_attacking = false  
		detection_radius = false

func _on_colisao_da_arma_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)  # Aplica dano ao jogador

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if detection_radius:
		attack()
	if anim_name == "attack" or "attack_2":
		if target and not detection_radius:
			is_attacking = false
			is_chasing = true
			current_state = State.CHASING
	if anim_name == "new_animation":
		Global.rat_elite_killed = true
		print("Global   ", Global.rat_elite_killed )
		queue_free()
		
		
	
		

func _on_timer_timeout() -> void:
	if direction_patrol == Vector2.RIGHT:
		direction_patrol = Vector2.LEFT
	elif direction_patrol == Vector2.LEFT:
		direction_patrol = Vector2.RIGHT
func die() -> void:
	sprite.visible = false
	target = null
	var die_effect = preload_die.instantiate()
	die_effect.position = global_position
	if self.is_in_group("Elite"):
		die_effect.scale.x = 2
		die_effect.scale.y = 2
	get_parent().add_child(die_effect)
	label_defeated.visible = true
	name_label.visible = false
	animation_defeated.play("new_animation")
	
	
func _slash_effect():
	var slash_effect = preload_slash_effect.instantiate()
	slash_effect.position = global_position
	get_parent().add_child(slash_effect)
func _spell_effect():
	var spell_effect = preload_spell_effect.instantiate()
	if self.is_in_group("Elite"):
		spell_effect.scale.x = 2
		spell_effect.scale.y = 2
	spell_effect.position = global_position
	get_parent().add_child(spell_effect)
	
