extends DirectionalLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (blend_mode == Light2D.BLEND_MODE_SUB):
		rotation_degrees = -90 + ($Timer.wait_time - $Timer.time_left) * (180 / $Timer.wait_time)
	else :
		rotation_degrees = -90 + ($Timer.wait_time - $Timer.time_left) * (180 / $Timer.wait_time)
	pass
	if ($Timer.time_left <= $Timer.wait_time / 8):
		energy = $Timer.time_left / ($Timer.wait_time / 8)
	elif ($Timer.time_left >= 7.0 * $Timer.wait_time / 8):
		energy = ($Timer.wait_time - $Timer.time_left) / ($Timer.wait_time / 8)
	else:
		energy = 1.0
	energy *= 1
func _on_timer_timeout() -> void:
	if (blend_mode == Light2D.BLEND_MODE_SUB):
		blend_mode = Light2D.BLEND_MODE_ADD
	else :
		blend_mode = Light2D.BLEND_MODE_SUB
