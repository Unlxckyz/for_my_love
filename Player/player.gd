extends CharacterBody2D

var speed = 100
var hp = 100
@onready var animation = $AnimationPlayer
@onready var sprite = $Elf
@onready var point = $PointWeapon  
@onready var sword_preload = preload("res://Weapons/Sword.tscn")
@onready var spell_preload = preload("res://spell.tscn")
@onready var spell_proj_preload = preload("res://spell_proj.tscn")
var last_direction = Vector2.ZERO
var sword_instance = null  
var spell_instance = null
var can_shoot_spell = true

func _ready() -> void:
	animation.play("Respawn")

func _process(delta: float) -> void:
	var direction = Vector2.ZERO 
	
	
	# Movimento e animação
	if Input.is_action_pressed("up"):
		direction.y -= 1
		_play_walk_animation()
	if Input.is_action_pressed("down"):
		direction.y += 1
		_play_walk_animation()
	if Input.is_action_pressed("right"):
		direction.x += 1
		animation.play("walk_right")
		last_direction = Vector2(1, 0)  
	if Input.is_action_pressed("left"):
		direction.x -= 1
		animation.play("walk_left")
		last_direction = Vector2(-1, 0)  

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = speed * direction
		move_and_slide()  
	else:
		_play_idle_animation()

	if Input.is_action_pressed("aim"):
		attack_close("sword")
	if Input.is_action_pressed("spell"):
		if can_shoot_spell:
			attack_close("spell")
		else:
			return
		
		
func _play_walk_animation() -> void:
	if last_direction.x > 0:
		animation.play("walk_right")
	elif last_direction.x < 0:
		animation.play("walk_left")

func _play_idle_animation() -> void:
	if last_direction == Vector2(1, 0):
		animation.play("idle_right")
	elif last_direction == Vector2(-1, 0):
		animation.play("idle_left")

func attack_close(type: String) -> void:
	if sword_instance == null and type == "sword":
		sword_instance = sword_preload.instantiate()
	elif spell_instance == null and type == "spell":
		spell_instance = spell_preload.instantiate()

	point.add_child(sword_instance if type == "sword" else spell_instance)
	(sword_instance if type == "sword" else spell_instance).position = Vector2.ZERO

	var weapon_animation = (sword_instance if type == "sword" else spell_instance).get_node("AnimationPlayer")
	var mouse_position = get_global_mouse_position()
	var player_position = global_position
	var direction_to_mouse = (mouse_position - player_position).normalized()

	if type == "spell":
		_cast_spell(direction_to_mouse)
	
	# Define a animação baseada na direção do mouse
	if abs(direction_to_mouse.x) > abs(direction_to_mouse.y):
		if direction_to_mouse.x > 0:
			weapon_animation.play("attack_right")
		else:
			weapon_animation.play("attack_left")
	else:
		if direction_to_mouse.y < 0:
			weapon_animation.play("attack_up")
		else:
			weapon_animation.play("attack_down")
func criaTimer(time):
	var new_timer = Timer.new()
	new_timer.wait_time = time
	new_timer.timeout.connect(Callable(self, "on_timer_timeout"))
	new_timer.start()
	
	
	
	
func _cast_spell(direction: Vector2) -> void:
	var point_spawn = spell_instance.get_node("Marker2D")
	var spell_proj = spell_proj_preload.instantiate()
	spell_proj.position = point_spawn.global_position
	spell_proj.direction = direction
	spell_proj.rotation = direction.angle()

	var spell_animation = spell_proj.get_node("AnimationPlayer")
	spell_animation.play("shoot")
	get_parent().add_child(spell_proj)
	criaTimer(1.0)
	can_shoot_spell = false
	
func on_timer_timeout():
	can_shoot_spell = true
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Respawn":
		last_direction = Vector2(1, 0)
