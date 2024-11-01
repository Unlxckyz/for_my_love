extends Node2D

@onready var animation = $AnimationPlayer
@onready var heart_3 = $Hud3
@onready var heart_2 = $Hud2
@onready var heart_1 = $Hud

# Atualiza a HUD e animações conforme a quantidade de vidas do jogador
func update_hearts():
	if Global.player_heart == 3:
		animation.play("3vidas")
	elif Global.player_heart == 2:
		if heart_3:  # Verifica se heart_3 ainda existe
			heart_3.queue_free()
			heart_3 = null  # Define como null após remover
			animation.play("3vidas")
	elif Global.player_heart == 1:
		if heart_2:  # Verifica se heart_2 ainda existe
			heart_2.queue_free()
			heart_2 = null  
			animation.play("3vidas")
			
	elif Global.player_heart == 0:
		if heart_1:  # Verifica se heart_1 ainda existe
			heart_1.queue_free()
			heart_1 = null  
		



func _physics_process(delta: float) -> void:
	update_hearts()

func _ready():
	animation.play("3vidas")
	update_hearts()  
