extends Node

var game_state = "lobby"
var game_mode = "bo3"
var p1_point = 0
var p2_point = 0
var round = 0

var infinit_time = 0


func end_game():
	print("end_game")

func end_round(point: int, b: bool):
	get_tree().current_scene.get_node("map_container").get_node("map").free()
	Network.client_player_ins.unequip_weapon()
	Network.client_player_ins.healt = 100
	Network.not_client_player_ins.healt = 100.0
	Network.not_client_player_ins.unequip_weapon()
	if (point == 1):
		p1_point += 1
	else:
		p2_point += 1
	if (b):
		Network.send_text(JSON.stringify(
			{
				"type": "end_round",
				"player_point": point
			}
		))
	if (p1_point == 2 || p2_point == 2):
		end_game()
	else:
		start_round(b)

func start_game(b: bool):
	game_state = "in_game"
	round = 1
	if (b):
		Network.send_text(JSON.stringify(
			{
				"type": "start_game",
				"mode": game_mode,
				"time": infinit_time
			}
		))
	start_round(b)

func start_round(b: bool):
	var map : PackedScene = load("res://scene/map/map_2.tscn")
	var map_ins = map.instantiate()
	get_tree().current_scene.get_node("map_container").add_child(map_ins)
	Network.spawn_player()
	if (b):
		Network.send_text(JSON.stringify(
			{
				"type": "start_round",
			}
		))
