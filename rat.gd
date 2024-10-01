extends CharacterBody2D

var speed = 50
@onready var target = get_tree().get_first_node_in_group("Player")
@onready var animation = $AnimationPlayer
func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	if target:
		direction = target.global_position - global_position
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = speed * direction
		if direction.x > 0:
			animation.play("walk_right")
		if direction.x < 0:
			animation.play("walk_left")
			
		move_and_slide()
