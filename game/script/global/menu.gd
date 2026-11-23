extends Control

var player_skin_id : int = 0;
var player_palette_id : int = 0;
	
func display_map_prev():
	var cell;
	var i = 2
	for clear in get_tree().current_scene.get_node("menu").get_node("CanvasLayer").get_node("game_leader").get_node("map_select").get_node("map_preview").get_children():
		clear.free()
	for t in range(2, Main.map.get_state().get_node_property_value(2, i).size(), 12):
		cell = ColorRect.new()
		cell.size = Vector2(10, 10)
		cell.color = Color(0.155, 0.377, 0.092, 1.0)
		if (Main.map.get_state().get_node_property_value(2, i)[t + 4] == 0):
			cell.color = Color(0.04, 0.054, 0.022, 1.0)
		cell.position = Vector2(10 * Main.map.get_state().get_node_property_value(2, i)[t], 10 * Main.map.get_state().get_node_property_value(2, i)[t + 2])
		get_tree().current_scene.get_node("menu").get_node("CanvasLayer").get_node("game_leader").get_node("map_select").get_node("map_preview").add_child(cell)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	display_map_prev()
	$CanvasLayer/not_client_info/player_connected/TextureRect.material = $CanvasLayer/not_client_info/player_connected/TextureRect.material.duplicate()
	$CanvasLayer/not_client_info/player_connected/TextureRect.texture = $CanvasLayer/not_client_info/player_connected/TextureRect.texture.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (Network.lobby_full == true):
		$CanvasLayer/game_leader/start.disabled = false
		$CanvasLayer/not_client_info/player_connected.show()
		$CanvasLayer/not_client_info/waiting_for_player.hide()
	if (Network.client_player_ins.player_id == 2):
		$CanvasLayer/not_game_leader.show()
		$CanvasLayer/not_client_info/player_connected.show()
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
	
	if ($CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.frame == 2):
		$CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.pause()
	if ($CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.frame == 2):
		$CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.pause()
	if ($CanvasLayer/client_info/next/AnimatedSprite2D.frame == 2):
		$CanvasLayer/client_info/next/AnimatedSprite2D.pause()
	if ($CanvasLayer/client_info/prev/AnimatedSprite2D.frame == 2):
		$CanvasLayer/client_info/prev/AnimatedSprite2D.pause()

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
	Network.client_player_ins.player_palette_id = player_palette_id
	Network.client_player_ins.update_skin()
	Network.send_text(JSON.stringify(
				{
					"type": "player_skin_update",
					"pal": player_palette_id,
					"skin_id": player_skin_id
				}
			))

func _on_prev_pal_pressed() -> void:
	player_palette_id -= 1
	if (player_palette_id == -1):
		player_palette_id = PlayerSkin.player_skin[player_skin_id][1].size() - 1
	$CanvasLayer/client_info/skin_selection/Label.text = PlayerSkin.player_skin[player_skin_id][1][player_palette_id][0]
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][1]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[player_skin_id][1][player_palette_id][2]))
	$CanvasLayer/client_info/TextureRect.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[player_skin_id][1][player_palette_id][3])
	Network.client_player_ins.player_palette_id = player_palette_id
	Network.client_player_ins.update_skin()
	Network.send_text(JSON.stringify(
				{
					"type": "player_skin_update",
					"pal": player_palette_id,
					"skin_id": player_skin_id
				}
			))

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
	Network.client_player_ins.player_palette_id = player_palette_id
	Network.client_player_ins.player_skin_id = player_skin_id
	Network.client_player_ins.update_skin()
	Network.send_text(JSON.stringify(
				{
					"type": "player_skin_update",
					"pal": player_palette_id,
					"skin_id": player_skin_id
				}
			))

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
	Network.client_player_ins.player_palette_id = player_palette_id
	Network.client_player_ins.player_skin_id = player_skin_id
	Network.client_player_ins.update_skin()
	Network.send_text(JSON.stringify(
				{
					"type": "player_skin_update",
					"pal": player_palette_id,
					"skin_id": player_skin_id
				}
			))


func _on_next_pal_mouse_entered() -> void:
	$CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.play("out")
	$CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.frame = 0


func _on_next_pal_mouse_exited() -> void:
	$CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.play("in")
	$CanvasLayer/client_info/skin_selection/next_pal/AnimatedSprite2D.frame = 0


func _on_prev_pal_mouse_entered() -> void:
	$CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.play("out")
	$CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.frame = 0


func _on_prev_pal_mouse_exited() -> void:
	$CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.play("in")
	$CanvasLayer/client_info/skin_selection/prev_pal/AnimatedSprite2D.frame = 0


func _on_next_mouse_entered() -> void:
	$CanvasLayer/client_info/next/AnimatedSprite2D.play("out")
	$CanvasLayer/client_info/next/AnimatedSprite2D.frame = 0


func _on_next_mouse_exited() -> void:
	$CanvasLayer/client_info/next/AnimatedSprite2D.play("in")
	$CanvasLayer/client_info/next/AnimatedSprite2D.frame = 0


func _on_prev_mouse_entered() -> void:
	$CanvasLayer/client_info/prev/AnimatedSprite2D.play("out")
	$CanvasLayer/client_info/prev/AnimatedSprite2D.frame = 0


func _on_prev_mouse_exited() -> void:
	$CanvasLayer/client_info/prev/AnimatedSprite2D.play("in")
	$CanvasLayer/client_info/prev/AnimatedSprite2D.frame = 0

#==============================================
#map select
#==============================================

func _on_map_1_pressed() -> void:
	Main.map = load("res://scene/map/map.tscn")
	Network.send_text(JSON.stringify(
		{"type": "map_change",
		"map": "map_1"}
	))
	display_map_prev()

func _on_map_2_pressed() -> void:
	Main.map = load("res://scene/map/map_2.tscn")
	Network.send_text(JSON.stringify(
		{"type": "map_change",
		"map": "map_2"}
	))
	display_map_prev()


func _on_forest_2_pressed() -> void:
	Main.map = load("res://scene/map/forest_2.tscn")
	Network.send_text(JSON.stringify(
		{"type": "map_change",
		"map": "forest2"}
	))
	display_map_prev()
