extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalEvent.map_action.connect(interact_map)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact_map(pos: Vector2):
	#======================================================================================
	#DOOR Interaction
	#======================================================================================
	print("patate ", pos)
	for i in $Wall.get_surrounding_cells(pos / 64):
		print($Wall.get_surrounding_cells(pos / 64))
		print($Wall.get_cell_source_id(i))
		if ($Wall.get_cell_source_id(i) == 0):
			if ($Wall.get_cell_tile_data(i).get_custom_data("door")):
				if ($Wall.get_cell_tile_data(i).get_custom_data("open")):
					$Wall.set_cell(i, 0, Vector2i(1, 0), $Wall.get_cell_alternative_tile(i))
					$Wall.set_cells_terrain_connect([i], 0, 1, true)
				else:
					$Wall.set_cell(i, 0, Vector2i(1, 1), $Wall.get_cell_alternative_tile(i))
					$Wall.set_cells_terrain_connect([i], 0, 2, true)
