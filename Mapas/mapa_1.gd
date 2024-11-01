extends Node2D
#fora de uso. porem util
@onready var preload_mob = preload("res://Enemies/rat.tscn")
@onready var path = $Path2D/PathFollow2D
@onready var timer = $Timer
var progress_ratios = [0.125, 0.625, 0.3755, 0.872]

func randomize_progress_ratio() -> void:
	progress_ratios = [0.125, 0.625, 0.3755, 0.872]
	var random_index = randi() % progress_ratios.size()  # Sorteia um índice
	progress_ratios = progress_ratios[random_index]  # Define o progress_ratio com o valor sorteado
func _spawn():
	randomize_progress_ratio()
	var mob = preload_mob.instantiate()
	path.progress_ratio = progress_ratios
	mob.global_position = path.position
	get_parent().add_child(mob)
	
	 

func _on_timer_timeout() -> void:
	
	_spawn()
