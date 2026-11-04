extends Node

#==============================================================
# name    | range | damege | path to the sprite          |	ray_color															|	path to the particule sprite
# "staff" | 50    | 30     | "assets/img/blue_staff.png" |	[Color(1.0, 1.0, 1.0, 0.0), Color(0.078, 0.357, 0.667, 1.0)]	|	
#==============================================================
var weapon_data = [
	["staff", 1000, 30, "res://assets/img/blue_staff.png", [Color(1.0, 1.0, 1.0, 0.0), Color(0.078, 0.357, 0.667, 1.0)], 0],
	["wand", 1500, 15,"res://assets/img/wand.png", [Color(1.0, 1.0, 1.0, 0.0), Color(0.536, 0.13, 0.636, 1.0)], 1]
]

func _ready() -> void:
	pass
