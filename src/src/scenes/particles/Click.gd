extends GPUParticles2D

func emit_and_free():
	emitting = true
	var time = (lifetime * 2) / speed_scale
	await get_tree().create_timer(time).timeout
	queue_free()
