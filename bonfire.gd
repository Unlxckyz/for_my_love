extends Area2D

var position_bonfire = null
var ativada = false
var player_in_area = false
@onready var animation = $AnimationPlayer

func _ready() -> void:
	position_bonfire = self.global_position
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not ativada:
		player_in_area = true
		Global.label_global.text = "Ativar bonfire [E]"
	elif body.is_in_group("Player") and ativada:
		Global.label_global.text = "Bonfire Ativada!"
		
		
func _physics_process(delta: float) -> void:
	if not ativada and player_in_area:
		if Input.is_action_pressed("interact"):
			Global.label_global.text = "Bonfire ativada!"
			animation.play("fire_active")
			ativada = true
			Global.last_checkpoint = position_bonfire


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fire_active":
		animation.play("fire_active_eterno")


func _on_body_exited(body: Node2D) -> void:
	player_in_area = false
	Global.label_global.text = ""
	
