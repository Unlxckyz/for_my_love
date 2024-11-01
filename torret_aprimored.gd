extends Node2D

var direction = Vector2.ZERO
var target: Node2D = null
var bullet_preload = preload("res://traps/torret_bullet.tscn")
var shoot = true
var hp = 3
@onready var spawn = $Marker2D
@onready var timer = $Timer
@export var timerz: float

func _ready() -> void:
	if timerz > 0:
		timer.wait_time = timerz
	timer.start()  # Inicia o temporizador

func shoot_bullet():
	if direction != Vector2.ZERO:
		var bullet = bullet_preload.instantiate()
		bullet.set_direction(direction.normalized())
		bullet.position = spawn.global_position
		bullet.rotation = direction.angle()
		
		var bullet_animation = bullet.get_node("AnimationPlayer")
		bullet_animation.play("shoot")
		
		get_parent().add_child(bullet)

func _physics_process(delta: float) -> void:
	if target:
		direction = target.global_position - global_position
	else:
		direction = Vector2.ZERO  # Reseta a direção se o alvo sair da área

func _on_timer_timeout() -> void:
	if target and direction != Vector2.ZERO:
		print("bullet saiu")
		shoot_bullet()

func disable_trap():
	timer.stop()
	shoot = false  # Desativa o disparo

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Jogador detectado")
		target = get_tree().get_first_node_in_group("Player")  # Define o alvo como o jogador

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Jogador saiu da area")
		target = null  # Remove o alvo se o jogador sair da área
