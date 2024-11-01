extends Marker2D

var rat_preload = preload("res://Enemies/rat.tscn")
@export var qtd_spawn = 5
var spawned_rats = []  # Lista para armazenar as instâncias dos ratos

func _ready():
	spawn()  # Tenta spawnar os ratos ao iniciar

func checkPlayerDeath():
	if Global.player_death:
		Global.player_death = false
		spawn()

func _physics_process(delta: float) -> void:
	checkPlayerDeath()

# Função para spawnar a quantidade de ratos como filhos do spawner
func spawn():
	# Verifica se já existem ratos spawnados
	if spawned_rats.size() > 0:
		return  # Já foi feito o spawn, então saímos da função
	
	# Spawna a quantidade definida de ratos
	for i in range(qtd_spawn):
		var rat_instance = rat_preload.instantiate()
		# Define uma posição aleatória ao redor do Spawner
		var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))
		rat_instance.position = self.position + random_offset  # Usa a posição local do spawner
		add_child(rat_instance)  # Adiciona o rato como filho do próprio spawner
		spawned_rats.append(rat_instance)  # Adiciona o rato à lista de instâncias spawnadas
