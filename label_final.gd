extends Label
# so copiei e modifiquei do outro
# Lista de textos para serem exibidos com o efeito de typewriter
var texts = [
	"Fim de jogo.",
	
	
]
var current_text_index = 0  # Índice do texto atual na lista
var full_text = ""  # Texto completo atual
var char_index = 0
var typewriter_speed = 0.05  # Velocidade básica do efeito
var dramatic_pause = 0.5  # Pausa dramática para palavras-chave
var text_pause = 2.0
var intro = true
var final = false
@onready var animation_player = $"../../AnimationPlayer"
@onready var final_windown =  $"../.."
# Palavras para ênfase e a posição para adicionar pausas
var dramatic_words = {
	"amor": 1.0,
	"feliz": 0.8,
	"joguinho": 0.7,
	"dedicação": 1.2,
	"inspiração": 1.0,
	"sorte": 0.8,
	"eterno": 1.0
}

func _ready():
	final_windown.visible = false
func _physics_process(delta: float) -> void:
	if Global.rat_elite_killed == true and not final:
		Global.is_chating = 0
		final_windown.visible = true
		final = true
		text = ""  # Começa com o texto vazio
		animation_player.play("fade_in")
		start_typewriter_effect()
		
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
