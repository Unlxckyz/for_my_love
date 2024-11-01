extends Node2D
#Controle de musica, ainda precisa de ajustes
var music_players = []
var current_music_index = 0
var transition_speed = 0.1  # Ajuste a velocidade de transição

func _ready():
	# Adiciona os nós das músicas ao array
	music_players = [$Music1, $Music2, $Music3, $Music4]

	# Conecta o sinal 'finished' de cada music player para tocar a próxima música automaticamente
	for player in music_players:
		player.connect("finished", Callable(self, "_on_music_finished"))

	# Começa a tocar a primeira música e assim por diante
	music_players[current_music_index].play()
	music_players[current_music_index].volume_db = 0  # Começa com volume máximo (0 dB)

func _on_music_finished():
	# efeito de transição
	fade_out_current_music()

func fade_out_current_music():
	var current_player = music_players[current_music_index]
	# Reduz o volume gradualmente
	while current_player.volume_db > -80:  # -80 dB é o mínimo no Godot
		current_player.volume_db -= transition_speed
		await get_tree().create_timer(0.1).timeout  # Espera antes de diminuir mais
	play_next_music()

func play_next_music():
	# Para a música atual
	music_players[current_music_index].stop()

	# Avança para a próxima música (com loop se quiser)
	current_music_index = (current_music_index + 1) % music_players.size()

	# Inicia o fade-in da próxima música
	var next_player = music_players[current_music_index]
	next_player.volume_db = -80  # Começa com o volume baixo
	next_player.play()
	fade_in_next_music()
func _physics_process(delta: float) -> void:
	# a ideia seria tocar o can feel my heart no boss mas pode ser feito de outra forma.
	if Global.can_spell == true:
		music_players[3].play()
func fade_in_next_music():
	var next_player = music_players[current_music_index]
	# Aumenta o volume gradualmente
	while next_player.volume_db < 0:
		next_player.volume_db += transition_speed
		await get_tree().create_timer(0.1).timeout  # Espera antes de aumentar mais
