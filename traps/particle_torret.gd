extends CPUParticles2D


func _on_finished() -> void:
	self.emitting = false
	queue_free() # Replace with function body.
