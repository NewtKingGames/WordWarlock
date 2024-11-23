extends CPUParticles2D

func _process(delta: float) -> void:
	speed_scale = 1 / Engine.time_scale
