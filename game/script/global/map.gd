extends Node2D


func delete():
	print("map free")
	self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalEvent.map_action.connect(interact_map)
	var rng = RandomNumberGenerator.new()

	
	for cell in $Wall/plant.get_used_cells_by_id(1, Vector2(0, 0)):
		var weapon = load("res://scene/item/loot_weapon.tscn")
		var weapon_ins : Area2D = weapon.instantiate()
		weapon_ins.weapon_id = rng.randi_range(0, 2)
		weapon_ins.global_position = cell * 64 + Vector2i(32.0, 32.0)
		get_tree().current_scene.get_node("map_container").get_node("map").get_node("weapons").add_child(weapon_ins)


	
	var player_spawn
	for cell in $Wall/plant.get_used_cells_by_id(1, Vector2(1, 0)):
		player_spawn = Marker2D.new()
		#player_spawn2 = 
		player_spawn.global_position = cell * 64 + Vector2i(32.0, 32.0)
		get_tree().current_scene.get_node("map_container").get_node("map").get_node("spawns").add_child(player_spawn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_map(pos: Vector2, sender : Node2D, b: bool):
	#======================================================================================
	#DOOR Interaction
	#======================================================================================
	
	if ($Wall.get_cell_source_id(pos/64) == 0 && sender.name == "RayBullet"):
		if ($Wall.get_cell_tile_data(pos/64).get_custom_data("door")):
			if ($Wall.get_cell_tile_data(pos/64).get_custom_data("open")):
				$Wall.set_cell(pos/64, 0, Vector2i(1, 0), $Wall.get_cell_alternative_tile(pos/64))
				$Wall.set_cells_terrain_connect([pos/64], 0, 1, true)
			else:
				$Wall.set_cell(pos/64, 0, Vector2i(1, 1), $Wall.get_cell_alternative_tile(pos/64))
				$Wall.set_cells_terrain_connect([pos/64], 0, 2, true)
	else:
		for i in $Wall.get_surrounding_cells(pos / 64):
			if ($Wall.get_cell_source_id(i) == 0):
				if ($Wall.get_cell_tile_data(i).get_custom_data("door")):
					if ($Wall.get_cell_tile_data(i).get_custom_data("open")):
						$Wall.set_cell(i, 0, Vector2i(1, 0), $Wall.get_cell_alternative_tile(i))
						$Wall.set_cells_terrain_connect([i], 0, 1, true)
					else:
						$Wall.set_cell(i, 0, Vector2i(1, 1), $Wall.get_cell_alternative_tile(i))
						$Wall.set_cells_terrain_connect([i], 0, 2, true)
	if (b):
		if (sender.name == "RayBullet"):
			Network.send_text(JSON.stringify(
				{
					"type": "door_open",
					"sender": "bullet",
					"pos": [pos.x, pos.y]
				}
			))
		else:
			Network.send_text(JSON.stringify(
				{
					"type": "door_open",
					"sender": "player",
					"pos": [pos.x, pos.y]
				}
			))


func autumn_mode():
	for name in DirAccess.get_files_at("res://assets/shader/shadermap/"):
		var shader : ShaderMaterial = load("res://assets/shader/shadermap/" + name)
		var palette_name : String = shader.get_shader_parameter("original_palettes").resource_path
		palette_name = palette_name.erase(palette_name.length() - 4, palette_name.length())
		shader.set_shader_parameter("new_palettes", load(palette_name + "_red.png"))
	for cell in $Wall/plant.get_used_cells():
		if ($Wall/plant.get_cell_tile_data(cell).material != null):
			$Wall/plant.get_cell_tile_data(cell).material.set_shader_parameter("new_palettes", load("res://assets/palette/map/palette_plant_red.png"))
	$Wall/plant.material.set_shader_parameter("new_palettes", load("res://assets/palette/map/palette_plant_red.png"))
	$Wall/plant/ground1.material.set_shader_parameter("new_palettes", load("res://assets/palette/map/palette_grass_red.png"))

func dark_mode():
	$Wall/plant/ground1.material = null
	$Wall/plant/ground1/ground0.material = null
	$mapcenter.show()
	$sun2.hide()
