extends Label
#50% eu e chat no dramatic_words
# Lista de textos para serem exibidos com o efeito de typewriter
var texts = [
	"Há uma força nas sombras, uma presença antiga que não toma o que é material... Ela rouba o que é mais precioso: os corações puros. Aqueles que caem sob seu domínio ficam aprisionados em um labirinto de emoções, perdidos para sempre, sempre e sempre...",
	"Tudo mudou num instante. No dia do seu casamento, o mundo desmoronou quando as sombras tomaram o que havia de mais profundo no homem que você amava: seu coração. Desde então, ele se tornou uma casca vazia, um corpo sem vontade de viver. Você o vê ali, vivo, mas distante, sem brilho nos olhos ou forças para responder ao mundo.",
	"Em busca de respostas, você mergulhou em lendas e histórias esquecidas e, lentamente, os indícios começaram a se revelar: outros casos, outros corações tomados e deixados em um estado de vazio. Agora, suas buscas a conduzem para uma caverna nas profundezas da terra, onde todas as pistas se encontram."
]
var current_text_index = 0  # Índice do texto atual na lista
var full_text = ""  # Texto completo atual
var char_index = 0
var typewriter_speed = 0.02  # Velocidade básica do efeito
var dramatic_pause = 0.5  # Pausa dramática para palavras-chave
var text_pause = 4.0
var intro = true
@onready var animation_player = $"../../AnimationPlayer"

# Palavras para ênfase e a posição para adicionar pausas
var dramatic_words = {
	"força": dramatic_pause,
	"sombras": dramatic_pause,
	"presença antiga": dramatic_pause,
	"rouba": dramatic_pause,
	"corações puros": dramatic_pause,
	"labirinto de emoções": dramatic_pause,
	"perdidos para sempre": dramatic_pause,
	"casamento": dramatic_pause,
	"desmoronou": dramatic_pause,
	"coração": dramatic_pause,
	"vazio": dramatic_pause,
	"caverna": dramatic_pause
}

func _ready():
	Global.is_chating = 0
	text = ""  # Começa com o texto vazio
	animation_player.play("skip?")
	start_typewriter_effect()
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("interact") and intro:
		animation_player.play("fade_out")
		intro = false
		Global.is_chating = 1
func start_typewriter_effect():
	full_text = texts[current_text_index]
	char_index = 0
	text = ""

	var timer = Timer.new()
	timer.wait_time = typewriter_speed
	timer.connect("timeout", Callable(self, "_on_typewriter_timeout"))
	add_child(timer)
	timer.start()

func _on_typewriter_timeout() -> void:
	if char_index < full_text.length():
		char_index += 1
		text = full_text.substr(0, char_index)

		# Verifica a presença de uma palavra-chave para dar uma pausa dramática
		for word in dramatic_words.keys():
			if text.ends_with(word):
				get_child(get_child_count() - 1).stop()
				await get_tree().create_timer(dramatic_words[word]).timeout
				get_child(get_child_count() - 1).start()
	else:
		get_child(get_child_count() - 1).queue_free()  # Remove o timer após terminar o efeito

		# Exibe o próximo texto na lista, se houver mais textos
		if current_text_index < texts.size() - 1:
			await get_tree().create_timer(text_pause).timeout
			current_text_index += 1
			start_typewriter_effect()
		else:
			if intro:
				animation_player.play("fade_out")
				Global.is_chating = 1
