extends Node

var game_state = "lobby"
var game_mode = "bo3"
var p1_point = 0
var p2_point = 0

var infinit_time = 0

func start_game(b: bool):
	if (b):
		Network.socket.send_text(JSON.stringify(
			{
				"type": "game_start",
				"mode": game_mode,
				"time": infinit_time
			}
		))
	start_round(b)

func end_game():
	get_tree().current_scene.get_node("menu").get_node("CanvasLayer").show()
	get_tree().current_scene.get_node("HUD").get_node("CanvasLayer").hide()
	p1_point = 0
	p2_point = 0

func end_round(point: int, b: bool):
	#for child in get_tree().current_scene.get_node("map_container").get_children():
	#	child.queue_free()
	get_tree().current_scene.get_node("map_container").get_node("map").delete()
	for child in get_tree().current_scene.get_node("not_client_player").get_children():
		child.queue_free()
	for child in get_tree().current_scene.get_node("map_container").get_children():
		print(child.name)
		for childc in child.get_children():
			print(childc.name)
	if (point == 1):
		p1_point += 1
	else :
		p2_point += 1
	var end = false
	if (p1_point == 2 || p2_point == 2):
		end = true
	#if (end):
	#	end_game()
	#	if (b):
	#		Network.socket.send_text(JSON.stringify(
	#			{
	#				"type": "end_game",
	#				"p1": p1_point,
	#				"p2": p2_point
	#			}
	#		))
	#else :
	if (b):
		Network.socket.send_text(JSON.stringify(
			{
				"type": "end_round",
				"player_point": point
			}
		))
	start_round(false)

func start_round(b: bool):
	var map = load("res://scene/map/map_2.tscn")
	var map_ins : Node2D = map.instantiate()
	get_tree().current_scene.get_node("map_container").add_child(map_ins)
	game_state = "in_round"
	Network.load_player()
	Network.client_player_ins.healt = 100
	get_tree().current_scene.get_node("HUD").healt = 100
	Network.client_player_ins.unquip_weapon()
	if (game_mode == "bo3"):
		if (p1_point == 2 || p2_point == 2):
			end_game()
	if (b):
		Network.socket.send_text(JSON.stringify(
			{
				"type": "start_round",
			}
		))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
