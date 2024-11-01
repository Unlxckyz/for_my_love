extends Node2D

var speed = 150
var direction = Vector2.ZERO
var damage = 30
@onready var audio = $AudioStreamPlayer
@onready var audio_impact = $AudioStreamPlayer2

# Posição inicial do objeto
var start_position = Vector2.ZERO
# Distância máxima permitida
var max_distance = 100  # Ajuste este valor conforme necessário

func _ready() -> void:
	# Armazena a posição inicial
	start_position = position
	audio.play()

func set_direction(dir: Vector2) -> void:
	direction = dir

func _process(delta: float) -> void:
	position += direction.normalized() * speed * delta

	# Verifica a distância da posição atual até a posição inicial
	if position.distance_to(start_position) > max_distance:
		queue_free()  # Remove o objeto da cena

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		if body.has_method("take_damage"):
			body._spell_effect()
			audio_impact.play()
			body.take_damage(damage)
