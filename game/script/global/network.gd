extends Node

@export var websocket_url = "ws://localhost:9080"

var socket = WebSocketPeer.new()

var player_list: Array = []
var player_ins_list: Array = []

var lobby_full = false

@onready var client_player_ins: CharacterBody2D = get_tree().current_scene.get_node("player")
var not_client_player_ins: CharacterBody2D

func pick_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func load_player():
	var new_player = load("res://scene/player/player.tscn")
	var player_ins : CharacterBody2D = new_player.instantiate()
	get_tree().current_scene.get_node("not_client_player").add_child(player_ins)
	player_ins.client_player = false
	if (client_player_ins.player_id == 1):
		player_ins.player_id = 2
	else:
		player_ins.player_id = 1
	not_client_player_ins = player_ins

func spawn_player():
	var spawn: Marker2D = pick_random_child(get_tree().current_scene.get_node("map_container").get_node("map").get_node("spawns"))
	client_player_ins.position = spawn.position

func set_client_player(client_player: CharacterBody2D):
	pass#client_player_ins = client_player

func send_text(text: String):
	var state = socket.get_ready_state()
	if (state == WebSocketPeer.STATE_OPEN):
		socket.send(text.to_utf8_buffer())

func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err == OK:
		print("connecting to %s..." % websocket_url)
		await get_tree().create_timer(2).timeout
		
		player_list.push_back(client_player_ins.player_id)
		player_ins_list.push_back(client_player_ins)
		send_text(JSON.stringify({"type": "new_connection"}))
	else:
		print("failed to connect :(")
		set_process(false)

func _process(_delta: float) -> void:
	
	socket.poll()
	
	var state = socket.get_ready_state()
	
	if (state == WebSocketPeer.STATE_OPEN):
		
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			var packet_text = packet.get_string_from_utf8()
			#print("< Got text data from server: %s" % packet_text)
			var packet_json = JSON.new()
			packet_json = JSON.parse_string(packet_text)
			var data: Dictionary = packet_json
			
			#=====================================================
			#pars json packet
			#=====================================================
			#print("JSON reçu : ", data)
			#print("Clés reçues : ", data.keys())
			
			#=========================================
			#from other client
			#=========================================
			if (data["type"] == "new_connection"):
				#var new_player = load("res://scene/player/player.tscn")
				#var player_ins : CharacterBody2D = new_player.instantiate()
				#get_tree().current_scene.get_node("not_client_player").add_child(player_ins)
				#player_ins.client_player = false
				#player_ins.player_id = 2
				##player_ins_list.push_back(player_ins)
				lobby_full = true
				player_list.push_back(2)
				load_player()
				send_text(JSON.stringify({"type": "player_list", "list": player_list}))
				
			if (data["type"] == "player_list"):
				client_player_ins.player_id = 2
				player_list = data["list"]
				load_player()
			
			if (data["type"] == "start_game"):
				Main.game_mode = data["mode"]
				Main.infinit_time = data["time"]
				Main.start_game(false)
				get_tree().current_scene.get_node("menu").get_node("CanvasLayer").hide()
				get_tree().current_scene.get_node("HUD").get_node("CanvasLayer").show()
			
			if (data["type"] == "door_open"):
				print("rcv door open")
				get_tree().current_scene.get_node("map_container").get_node("map").interact_map(Vector2(float(data["pos"][0]), float(data["pos"][1])), Network.not_client_player_ins, false)
			
			#if (data["type"] == "start_round"):
			#	Main.start_round(false)
			
			if (data["type"] == "end_round"):
				Main.end_round(data["player_point"], false)
			
			if (data["type"] == "map_change"):
				if (data["map"] == "map_1"):
					Main.map = load("res://scene/map/map.tscn")
				elif (data["map"] == "map_2"):
					Main.map = load("res://scene/map/map_2.tscn")
				elif (data["map"] == "forest2"):
					Main.map = load("res://scene/map/forest_2.tscn")
			
			if (data["type"] == "player_skin_update"):
				not_client_player_ins.player_palette_id = int(data["pal"])
				not_client_player_ins.player_skin_id = int(data["skin_id"])
				not_client_player_ins.update_skin()
				if (Main.game_state == "lobby"):
					var tex_rec: TextureRect = get_tree().current_scene.get_node("menu").get_node("CanvasLayer").get_node("not_client_info").get_node("player_connected").get_node("TextureRect")
					tex_rec.texture.atlas = load(PlayerSkin.player_skin[int(data["skin_id"])][0])
					tex_rec.material.set_shader_parameter("original_palettes", load(PlayerSkin.player_skin[int(data["skin_id"])][1][int(data["pal"])][1]))
					tex_rec.material.set_shader_parameter("new_palettes", load(PlayerSkin.player_skin[int(data["skin_id"])][1][int(data["pal"])][2]))
					tex_rec.material.set_shader_parameter("colors_counts", PlayerSkin.player_skin[int(data["skin_id"])][1][int(data["pal"])][3])
			
			if (data["type"] == "hitmarker"):
				var hit = load("res://scene/item/hit_marker.tscn")
				var hit_ins: Node2D = hit.instantiate()
				hit_ins.from_client = false
				hit_ins.global_position.x = int(data["pos"][0])
				hit_ins.global_position.y = int(data["pos"][1])
				#var part: GPUParticles2D = hit_ins.get_node("Marker2D").get_node("GPUParticle2D")
				#var tex: AnimatedTexture = part.texture
				#tex.current_frame = int(data["tex"])
				get_tree().current_scene.add_child(hit_ins)
				
			#player update
			if (get_tree().current_scene.get_node("not_client_player").get_child_count() > 0):
				if (data["type"] == "player_update" ||
						data["type"] == "player_equip_weapon" ||
						data["type"] == "player_drop_weapon" ||
						data["type"] == "player_shoot"):
					var child = get_tree().current_scene.get_node("not_client_player").get_node("player")
					if child.player_id == data["id"]:
						if (data["type"] == "player_update"):
							child.update_player(data)
						elif (data["type"] == "player_equip_weapon"):
							child.interact_with_loot_not_client()
						elif (data["type"] == "player_drop_weapon"):
							child.drop_weapon()
						elif (data["type"] == "player_shoot"):
							child.shoot_particule_network(data)
			if (data["type"] == "player_get_hit"):
				client_player_ins.get_hit(data["dmg"], false)
			
			#====================================
			#from server
			#====================================
			if (data["type"] == "player_disconected"):
				for child in get_tree().current_scene.get_node("not_client_player").get_children():
					child.queue_free()
				client_player_ins.player_id = 1
				player_list.clear()
				player_list.push_back(1)
		
	elif (state == WebSocketPeer.STATE_CLOSING):
		pass
		
		
	elif (state == WebSocketPeer.STATE_CLOSED):
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false)
