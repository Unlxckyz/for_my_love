extends Node2D

var heart = Global.player_heart
@onready var animation = $AnimationPlayer


func checkHearts():
	if Global.player_heart == 3:
		animation.play("3vidas")
	if Global.player_heart == 2:
		animation.play("2vidas")
	if Global.player_heart == 1:
		animation.play("1vida")
	if Global.player_heart == 0:
		animation.play("0vidas")
		
func _physics_process(delta: float) -> void:
	checkHearts()
