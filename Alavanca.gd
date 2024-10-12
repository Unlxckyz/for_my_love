extends Area2D

@onready var label_global = $"../../CanvasLayer/Label"
@onready var animation = $AnimationPlayer
var active = false
var can_interact = false
@export var label_text = "Desarmar Armadilhas [E]"
@export var success_text = "Armadilhas desativadas!"

func _process(delta: float) -> void:
	if Input.is_action_pressed("interact") and can_interact:
		interact()

func interact():
	if not active:
		animation.play("off")  # Animação da interação principal
		active = true
		# Desativar todas as armadilhas no grupo "traps"
		var traps = get_tree().get_nodes_in_group("traps")
		for trap in traps:
			if trap.has_method("disable_trap"):
				trap.disable_trap()  # Chama a função de desativação em cada trap
				# Atualiza o texto de confirmação para o jogador
				label_global.text = success_text
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not active:
		label_global.text = label_text
		can_interact = true
	elif active:
		label_global.text = success_text

func _on_body_exited(body: Node2D) -> void:
	can_interact = false
	label_global.text = ""
