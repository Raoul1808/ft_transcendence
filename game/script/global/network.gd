extends Node

@export var websocket_url = "ws://localhost:9080"

var socket = WebSocketPeer.new()

var player_list: Array = []
var player_ins_list: Array = []

@onready var client_player_ins: CharacterBody2D = get_tree().current_scene.get_node("player")

func set_client_player(client_player: CharacterBody2D):
	pass#client_player_ins = client_player

func socket_send_text(text: String):
	socket.send_text(text)

func _ready():
	var err = socket.connect_to_url(websocket_url)
	if err == OK:
		print("connecting to %s..." % websocket_url)
		await get_tree().create_timer(2).timeout
		
		player_list.push_back(client_player_ins.player_id)
		player_ins_list.push_back(client_player_ins)
		socket.send_text(JSON.stringify({"type": "new_connection"}))
	else:
		print("failed to connect :(")
		set_process(false)

func _process(delta: float) -> void:
	
	socket.poll()
	
	var state = socket.get_ready_state()
	
	if (state == WebSocketPeer.STATE_OPEN):
		
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				print("< Got text data from server: %s" % packet_text)
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
					var new_player = load("res://scene/player/player.tscn")
					var player_ins : CharacterBody2D = new_player.instantiate()
					get_tree().current_scene.get_node("not_client_player").add_child(player_ins)
					player_ins.client_player = false
					player_ins.player_id = 2
					player_ins_list.push_back(player_ins)
					player_list.push_back(player_ins.player_id)
					socket.send_text(JSON.stringify({"type": "player_list", "list": player_list}))
					
				if (data["type"] == "player_list"):
					client_player_ins.player_id = 2
					player_list = data["list"]
					for i : int in player_list.size():
						if player_list[i] != client_player_ins.player_id:
							var new_player = load("res://scene/player/player.tscn")
							var player_ins : CharacterBody2D = new_player.instantiate()
							get_tree().current_scene.get_node("not_client_player").add_child(player_ins)
							player_ins.client_player = false
							player_ins.player_id = 1
				
				#player update
				if (data["type"] == "player_update" ||
						data["type"] == "player_equip_weapon" ||
						data["type"] == "player_drop_weapon" ||
						data["type"] == "player_get_hit"):
					for child in get_tree().current_scene.get_node("not_client_player").get_children():
						if child.player_id == data["id"]:
							if (data["type"] == "player_update"):
								child.update_player(data)
							elif (data["type"] == "player_equip_weapon"):
								child.equip_weapon(data["weapon"])
							elif (data["type"] == "player_drop_weapon"):
								child.drop_weapon()
							elif (data["type"] == "player_get_hit"):
								child.get_hit(data["dmg"])
					
				
				#====================================
				#from server
				#====================================
				if (data["type"] == "player_disconected"):
					for child in get_tree().current_scene.get_node("not_client_player").get_children():
						child.queue_free()
					client_player_ins.player_id = 1
					player_list.clear()
					player_list.push_back(1)
					
				
			else:
				print("< Got binary data from server: %d bytes" % packet.size())
		
		
	elif (state == WebSocketPeer.STATE_CLOSING):
		pass
		
		
	elif (state == WebSocketPeer.STATE_CLOSED):
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false)
