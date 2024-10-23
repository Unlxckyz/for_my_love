extends CharacterBody2D
class_name Player
# Character Stats
@export var speed = 80
@export var health = 50
@export var mp: int # Mana Points (MP)
@export var vit: int # Vitality (affects health)
@export var wis: int # Wisdom (affects magic-related stats)
@export var att: int # Attack power
@export var def: int # Defense
@export var dex: int # Dexterity (affects agility, evasion, etc.)
@export var fame: int 
#Items
@onready var sword_preload = preload("res://Weapons/Sword.tscn")
@onready var spell_preload = preload("res://Weapons/Spells/InitialSpell/spell.tscn")
@onready var mine_preload = preload("res://Weapons/tools/picareta.tscn")

var sword = null
var spell = null
var mine = null
# Experience and Leveling
@export var xp: int
@export var xp_to_level_up: int
@export var level: int


#CharacterUI
@onready var animation = $AnimationPlayer
@export var PointWeapon = Marker2D

#Miscellanius
var last_direction
var direction = Vector2.ZERO
var hurt = false
var respawn = false
var is_chating = Global.is_chating
var can_sword = Global.can_sword

# Skills
@export var skills = Array()

func _process(delta: float) -> void:
	
	
	if Global.is_chating == 0:
		if last_direction == "left":
			animation.play("idle_left")
		else:
			animation.play("idle_right")
		return
	if not hurt and respawn:
		move()
		
		checkAttack()
	if not respawn:
		animation.play("Respawn")
		
		
	if mine != null:
		mine.position = PointWeapon.global_position
	if sword != null:
		sword.position = PointWeapon.global_position
	if spell != null:
		spell.position = global_position

func _ready() -> void:
	animation = $AnimationPlayer
	
	last_direction = "right"
	
	

#Funçoes de Movimento

func move():
	direction = Vector2.ZERO 
	if Input.is_action_pressed("up"):
		direction.y -= 1
		check_last_direction()
	if Input.is_action_pressed("down"):
		direction.y += 1
		check_last_direction()
		
	if Input.is_action_pressed("right"):
		direction.x += 1
		animation.play("walk_right")
		last_direction = "right"
	if Input.is_action_pressed("left"):
		direction.x -= 1
		animation.play("walk_left")
		last_direction = "left" 

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = speed * direction
		move_and_slide()  
	else:
		check_idle()
		
		
func check_last_direction():
	if last_direction == "right":
		animation.play("walk_right")
	if last_direction == "left":
		animation.play("walk_left")
		
func check_idle():
	if direction == Vector2.ZERO and last_direction == "right":
			animation.play("idle_right")
	elif direction == Vector2.ZERO and last_direction == "left":
		animation.play("idle_left")

#Funçoes para ataque

func checkAttack():
	var direction_mouse = get_local_mouse_position()
	if Input.is_action_pressed("aim") and sword == null and Global.can_sword:
		sword = sword_preload.instantiate()
		sword.position = PointWeapon.global_position
		sword.direction = direction_mouse
		get_parent().add_child(sword)
		var animation_sword = sword.get_node("AnimationPlayer")
		checkPositionMouseToAttack(direction_mouse,animation_sword)
	if Input.is_action_pressed("spell") and spell == null:
		spell = spell_preload.instantiate()
		spell.position = global_position
		get_parent().add_child(spell)
		var spell_animation = spell.get_node("AnimationPlayer")
		spell_animation.play("attack_down")
	if Input.is_action_just_pressed("mine") and mine == null:
		mine = mine_preload.instantiate()
		mine.position = PointWeapon.global_position
		mine.direction = direction_mouse
		get_parent().add_child(mine)
		var mine_animation = mine.get_node("AnimationPlayer")
		checkPositionMouseToAttack(direction_mouse,mine_animation)
		
		
		
		
		
	
		
func checkPositionMouseToAttack(direction_mouse,animation_sword):
	if abs(direction_mouse.x) > abs(direction_mouse.y):
		if direction_mouse.x > 0:
			animation_sword.play("attack_right")  # Mouse à direita
		else:
			animation_sword.play("attack_left")  # Mouse à esquerda
	else:
		
		if direction_mouse.y > 0:
			animation_sword.play("attack_down")  # Mouse para baixo
		else:
			animation_sword.play("attack_up")  # Mouse para cima
		
func take_damage(damage):
	print("Voce levou: ", damage)
	Global.hp_player -= damage
	if last_direction == "right":
		animation.play("hurt")
	else:
		animation.play("hurt_left")
	
	hurt = true
	if Global.hp_player <=0:
		Global.player_heart -= 1
	if Global.player_heart < 0:
		get_tree().reload_current_scene()
		
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt" or "hurt_left":
		hurt = false
	if anim_name == "Respawn":
		respawn = true
