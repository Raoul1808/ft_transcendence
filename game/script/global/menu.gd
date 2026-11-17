extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Network.lobby_full == true):
		$CanvasLayer/game_leader/start.disabled = false
		$CanvasLayer/not_client_info/player_connected.show()
		$CanvasLayer/not_client_info/waiting_for_player.hide()
	if (Network.client_player_ins.player_id == 2):
		$CanvasLayer/not_game_leader.show()
		$CanvasLayer/game_leader.hide()
	else :
		$CanvasLayer/not_game_leader.hide()
		$CanvasLayer/game_leader.show()
	if ($CanvasLayer/game_leader/start/AnimatedSprite2D.frame == 2):
		$CanvasLayer/game_leader/start/AnimatedSprite2D.pause()
	if ($CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.frame == 2):
		$CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.pause()
	if ($CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.frame == 2):
		$CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.pause()

func _on_start_pressed() -> void:
	Main.start_game(true)
	$CanvasLayer.hide()
	get_tree().current_scene.get_node("HUD").get_node("CanvasLayer").show()

func _on_start_mouse_entered() -> void:
	$CanvasLayer/game_leader/start/AnimatedSprite2D.play("out")
	$CanvasLayer/game_leader/start/AnimatedSprite2D.frame = 0

func _on_start_mouse_exited() -> void:
	$CanvasLayer/game_leader/start/AnimatedSprite2D.play("in")
	$CanvasLayer/game_leader/start/AnimatedSprite2D.frame = 0


func _on_map_1_mouse_entered() -> void:
	$CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.play("out")
	$CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.frame = 0


func _on_map_1_mouse_exited() -> void:
	$CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.play("in")
	$CanvasLayer/game_leader/map_select/map1/AnimatedSprite2D.frame = 0


func _on_map_2_mouse_entered() -> void:
	$CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.play("out")
	$CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.frame = 0


func _on_map_2_mouse_exited() -> void:
	$CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.play("in")
	$CanvasLayer/game_leader/map_select/map2/AnimatedSprite2D.frame = 0
