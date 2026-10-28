extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Network.player_list.size() > 1):
		$CanvasLayer/game_leader/start.disabled = false
		$CanvasLayer/not_client_info/player_connected.show()
		$CanvasLayer/not_client_info/waiting_for_player.hide()
	if (Network.client_player_ins.player_id == 2):
		$CanvasLayer/not_game_leader.show()
		$CanvasLayer/game_leader.hide()
	else :
		$CanvasLayer/not_game_leader.hide()
		$CanvasLayer/game_leader.show()

func _on_start_pressed() -> void:
	Main.start_game()
	$CanvasLayer.hide()
	get_tree().current_scene.get_node("HUD").get_node("CanvasLayer").show()
