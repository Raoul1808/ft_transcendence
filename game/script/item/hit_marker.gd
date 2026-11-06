extends Node2D

@export var from_client: bool = true

func _ready() -> void:
	$Marker2D/GPUParticles2D.emitting = true
	if (from_client):
		Network.socket.send_text(JSON.stringify(
			{
				"type": "hitmarker",
				"pos": [global_position.x, global_position.y],
				"tex": WeaponData.weapon_data[Network.client_player_ins.weapon][5]
			}
		))

func _process(delta: float) -> void:
	if ($Marker2D/PointLight2D.energy > 0):
		$Marker2D/PointLight2D.energy -= 0.1
	
func _on_timer_timeout() -> void:
	queue_free()
