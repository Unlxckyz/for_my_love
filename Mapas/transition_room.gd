extends Area2D

var is_active: bool = true  # Variável para controlar a atividade do teleporter
@onready var timer = $Timer

func find_closest_marker(player_position: Vector2) -> Marker2D:
	var closest_marker: Marker2D = null
	var min_distance = INF
	
	#obtem os nós ne de teleport
	var markers = get_tree().get_nodes_in_group("teleport_markers")

	# Itera pelos nós do grupo
	for marker in markers:
		if marker is Marker2D: 
			var distance = player_position.distance_to(marker.global_position)
			
			# Define uma distância mínima aceitável para ignorar o marcador atual
			if distance > 20:  
				if distance < min_distance:
					min_distance = distance
					closest_marker = marker
	
	return closest_marker

# Quando o player entra na Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and is_active:
		var closest_marker = find_closest_marker(body.global_position)
		if closest_marker:
			is_active = false
			# Desativar a colisão do player momentaneamente para evitar loops
			body.set_deferred("collision_layer", 0)
			body.global_position = closest_marker.global_position
			# Desativa o teleporter
			timer.start()

# Quando o timer acaba, reativa o teleporter
func _on_timer_timeout() -> void:
	is_active = true
	# Reativa a colisão do player após um tempo
	get_tree().get_first_node_in_group("Player").set_deferred("collision_layer", 1)
