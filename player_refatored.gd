extends CharacterBody2D

# Character Stats
@export var speed: float
@export var health: int
@export var mp: int # Mana Points (MP)
@export var vit: int # Vitality (affects health)
@export var wis: int # Wisdom (affects magic-related stats)
@export var att: int # Attack power
@export var def: int # Defense
@export var dex: int # Dexterity (affects agility, evasion, etc.)
@export var fame: int 

# Experience and Leveling
@export var xp: int
@export var xp_to_level_up: int
@export var level: int

#CharacterUI
@export var animation = AnimationPlayer

#Miscellanius
var last_direction
var direction = Vector2.ZERO


# Skills
@export var skills = Array()

func _ready() -> void:
	animation = $AnimationPlayer

func move():
	var direction = Vector2.ZERO 
	
	
	# Movimento e animação
	if Input.is_action_pressed("up"):
		direction.y -= 1
		check_last_direction()
	if Input.is_action_pressed("down"):
		direction.y += 1
		if last_direction == "left":
			animation.play("walk_left")
			check_last_direction()
		
	if Input.is_action_pressed("right"):
		direction.x += 1
		animation.play("walk_right")
		last_direction = Vector2(1, 0)  
	if Input.is_action_pressed("left"):
		direction.x -= 1
		animation.play("walk_left")
		last_direction = "left" 

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = speed * direction
		move_and_slide()  
	else:
		check_last_direction()
		
func check_last_direction():
	if last_direction == "right":
		animation.play("walk_right")
	if last_direction == "left":
		animation.play("walk_left")
	if direction == Vector2.ZERO and direction == "right":
		animation.play("idle_right")
		
