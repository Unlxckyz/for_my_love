extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var animation = $AnimationTree
@onready var timer = $Timer
@onready var timer_can_move = $Timer2
@onready var baloon_new = $Sprite2D/new
@onready var baloon_chatting = $Sprite2D/chatting
var is_chat = false
var player_in_area = false
var can_move = true
var direction = Vector2.ZERO
var direita = true
var speed = 40
var last_direction = "right"
var count = 0


func _ready() -> void:
	Dialogic.signal_event.connect(DialogicSignal)

func _physics_process(delta: float) -> void:
	if player_in_area and not is_chat and Input.is_action_pressed("interact"):
		handle_dialogue()

	if not is_chat and can_move:
		move_character()

	update_animation()

func handle_dialogue() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	Global.is_chating = 0
	
	# Ajuste para determinar se o player está à direita ou à esquerda
	if player.global_position.x > global_position.x:
		sprite.flip_h = false  # Player está à direita, personagem olha para a direita
		last_direction = "right"
	else:
		sprite.flip_h = true  # Player está à esquerda, personagem olha para a esquerda
		last_direction = "left"
	
	# Controle do diálogo
	if Global.first_time_saimon == 0:
		run_dialogue("saimonTimeline")
		Global.first_time_saimon += 1
		baloon_new.visible = false
		baloon_chatting.visible = true
		
	elif Global.first_time_saimon == 1:
		run_dialogue("saimonTimeline2")
		baloon_chatting.visible = true
	else:
		run_dialogue("saimonTimeline3")
		baloon_chatting.visible = true

func move_character() -> void:
	if direita:
		move(Vector2.RIGHT)
	else:
		move(Vector2.LEFT)

func update_animation() -> void:
	if is_chat or direction == Vector2.ZERO:
		animation.play("idle")
		sprite.flip_h = last_direction == "left"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true
	elif body is TileMapLayer:
		toggle_direction()

func toggle_direction() -> void:
	direita = not direita

func run_dialogue(dialogue_string: String) -> void:
	is_chat = true
	can_move = false
	Global.is_chating = 0
	Dialogic.start(dialogue_string)

func DialogicSignal(arg: String) -> void:
	if arg == "exit_saimon":
		baloon_chatting.visible = false
		is_chat = false
		can_move = true
		Global.is_chating = 1
	elif arg == "espada_saimon":
		Global.can_sword = true
	elif arg == "final_timeline2":
		Global.first_time_saimon += 1

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false

func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.5, 1.3)
	if count < 4:
		toggle_direction()

func move(direction_to_move: Vector2) -> void:
	direction = direction_to_move
	sprite.flip_h = direction_to_move == Vector2.LEFT
	animation.play("walk_right")
	
	if direction_to_move == Vector2.LEFT:
		last_direction = "left"
	else:
		last_direction = "right"
	
	direction = direction.normalized()
	velocity = speed * direction
	move_and_slide()

func _on_timer_2_timeout() -> void:
	can_move = not can_move
	if not can_move:
		animation.play("idle")
