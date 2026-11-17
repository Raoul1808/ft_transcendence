extends Control

var player_skin_id : int = 0;
var player_palette_id : int = 0;

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
	
	
	
	
	#======================================================================================
	#button animation
	#======================================================================================
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


func _on_next_pal_pressed() -> void:
	player_palette_id += 1
	if (player_palette_id == PlayerSkin.player_skin[player_skin_id][1].size()):
		player_palette_id = 0
	$CanvasLayer/client_info/skin_selection/Label.text = PlayerSkin.player_skin[player_skin_id][1][player_palette_id][0]
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])

func _on_prev_pal_pressed() -> void:
	player_palette_id -= 1
	if (player_palette_id == -1):
		player_palette_id = PlayerSkin.player_skin[player_skin_id][1].size() - 1
	$CanvasLayer/client_info/skin_selection/Label.text = PlayerSkin.player_skin[player_skin_id][1][player_palette_id][0]
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])


func _on_next_pressed() -> void:
	#print($CanvasLayer/client_info/TextureRect.texture.atlas)
	#var t : AtlasTexture
	#t.
	player_palette_id = 0
	player_skin_id += 1
	if (player_skin_id == PlayerSkin.player_skin.size()):
		player_skin_id = 0
	$CanvasLayer/client_info/TextureRect.texture.atlas = load(PlayerSkin.player_skin[player_skin_id][0])
	$CanvasLayer/client_info/skin_selection/Label.text = PlayerSkin.player_skin[player_skin_id][1][player_palette_id][0]
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])

func _on_prev_pressed() -> void:
	player_palette_id = 0
	player_skin_id -= 1
	if (player_skin_id == -1):
		player_skin_id = PlayerSkin.player_skin.size() - 1
	$CanvasLayer/client_info/TextureRect.texture.atlas = load(PlayerSkin.player_skin[player_skin_id][0])
	$CanvasLayer/client_info/skin_selection/Label.text = PlayerSkin.player_skin[player_skin_id][1][player_palette_id][0]
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])
