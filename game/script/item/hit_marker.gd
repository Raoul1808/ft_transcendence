extends Node2D

func _ready() -> void:
	$Marker2D/GPUParticles2D.emitting = true

func _process(delta: float) -> void:
	if ($Marker2D/PointLight2D.energy > 0):
		$Marker2D/PointLight2D.energy -= 0.1
	
func _on_timer_timeout() -> void:
	queue_free()
