extends weapons
@onready var proj_preload = preload("res://spell_proj.tscn")
@onready var spawn_point = $spawn
var proj = null
func init():
	knockback_force = 0
	damage = 20
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_right" or "attack_left" or "attack_up" or "attack_down":
		queue_free()
func _process(delta: float) -> void:
	
	pass
	
func _ready():
	var direction_mouse = get_local_mouse_position()
	proj = proj_preload.instantiate()
	proj.direction = direction_mouse
	proj.rotation = direction_mouse.angle()
	proj.position = spawn_point.global_position

	var proj_animation = proj.get_node("AnimationPlayer")
	get_parent().add_child(proj)
	proj_animation.play("shoot")
	
	
