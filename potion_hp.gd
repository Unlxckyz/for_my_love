extends CharacterBody2D
@onready var direction = Vector2.ZERO
@onready var speed = 30
@onready var target_distance = 20  

func moveToPlayer(player: Node2D) -> void:
	direction = (player.global_position - global_position).normalized()  
	velocity = direction * speed
	move_and_slide()

func _on_potion_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		moveToPlayer(body)

func _process(delta):
	var player = get_tree().get_first_node_in_group("Player")
	if player and global_position.distance_to(player.global_position) <= target_distance:
		moveToPlayer(player)
	
		if global_position.distance_to(player.global_position) < 10:
			Global.potions_hp += 1
			queue_free()  
