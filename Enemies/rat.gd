extends Enemy

func _init() -> void:
	health = 25
	speed = 40

var caudas_preload = preload("res://caudas.tscn")

# Função chamada quando o inimigo recebe dano

# Função para determinar a chance de drop da cauda
func try_drop_cauda():
	var drop_chance = randf()  # Gera um número aleatório entre 0 e 1
	
	# Define uma chance de 30% para dropar a cauda
	if drop_chance <= 0.5:
		var caudas = caudas_preload.instantiate()
		caudas.position = global_position  # Define a posição do item
		add_child(caudas)  # Adiciona o item como filho da cena


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.take_damage(10)
